
### Заметки по постройке видеолинка с двусторонней телеметрией mavlink

Воздушная часть линка представляет из себя камеру [gk7205v200](https://sl.aliexpress.ru/p?key=e1sTwWg) с подключенным по USB wifi-адаптером на чипе rtl8812au, например ASUS USB AC-56 или [недорогого более слабого адаптера с ali](https://sl.aliexpress.ru/p?key=8CsTwDB).
Наземная часть - это [видеорегистратор](https://sl.aliexpress.ru/p?key=L1sTwWG) на базе чипа hisilicon hi3536dv100 либо ev100, к которому точно так же подключен по USB адаптер rtl8812au или rtl8814au. Для РФ дешевле и быстрее заказать камеру и регистратор у [@ser177](https://t.me/ser177).
Данная статья описывает нюансы создания подобного линка, и является дополнением к [этой статье](https://github.com/OpenIPC/wiki/blob/master/ru/fpv.md).

![link_hw](https://github.com/OpenIPC/sandbox-fpv/raw/master/notes_files/link_hw.png)

### Возможности

Данный линк [способен передавать видео](https://github.com/OpenIPC/sandbox-fpv/blob/master/notes_files/mp_h265.png) [(скачать avi)](https://github.com/OpenIPC/sandbox-fpv/raw/master/notes_files/2023-03-18%2002-49-40.avi) с воздушной части форматом (разрешение@частота кадров) 1920x1080@30 или 1280x720@50 кодеками h264 либо h265 и телеметрию mavlink в обе стороны. Общая схема процессов для передачи видео выглядит так:

![video](https://github.com/OpenIPC/sandbox-fpv/raw/master/notes_files/video.png)

Передача видео на текущий момент возможна двумя способами. Классический - streamer `majestic` через udp порт 5600 засылает RTP/h264 или RTP/h265 поток  в [wfb-ng](https://github.com/svpcom/wfb-ng) для передачи на землю, где принимается ответной частью wfb-ng и отправляется для воспроизведения на PC или планшет / смартфон по LAN или USB ethernet (tethering). Формат RTP свободно воспроизводится программами для GS, такими как [QGroundControl](https://github.com/mavlink/qgroundcontrol), [Mission Planner](https://ardupilot.org/planner/) или [FPV-VR](https://github.com/Consti10/FPV_VR_OS). Но его пока невозможно вывести в порт HDMI регистратора, поскольку он построен на специализированном чипе со своим SDK и обычными способами, например через GStreamer как обычно выводят видео в случае Raspberry Pi, этого не сделать.

<sub>QGroundControl имеет баг при воспроизведении h265, проявляющийся в зависании картинки при входе в меню. Это лечится до перезапуска программы выбором потока видео h264 и назад h265.</sub>

Andrey Bezborodov из команды OpenIPC предоставил на тесты скомпилированные примеры *vencoder* и *vdecoder*, вытащенные из Hisilicon SDK и в оригинальном виде расположенные [тут](https://github.com/OpenIPC/silicon_research). `venc` запускается на камере и формирует поток h264 с фрагментацией HAL вместо `majestic`, `vdec` на регистраторе выводит этот поток в HDMI. Все работает, но естественно нет OSD и подобный нестандартный поток невозможно воспроизвести сторонними плеерами. Это очень перспективный путь, поскольку имеет возможности к снижению задержки передачи видео. На текущий момент она составляет от 110 до 130 мсек. На "классической схеме" задержки составляют обычно от 150 до 230 мсек, в зависимости от разрешения и наземных условий воспроизведения.

Этот вопрос можно решить, "научив" `vdec` распознавать RTP/h26[4-5] с помощью библиотеки *libavformat/avformat.h* и по прежнему "стримить" на камере через `majestic`. Для этого нужна помощь программиста C++, если вы желаете помочь проекту с этим - [обращайтесь](https://t.me/+BMyMoolVOpkzNWUy).

Пример настройки *GStreamer* на Mission Planner для воспроизведения h265: `udpsrc port=5600 buffer-size=90000 ! application/x-rtp ! rtph265depay ! avdec_h265 ! videoconvert ! video/x-raw,format=BGRA ! appsink name=outsink`

Поддерживаются частоты от 5,2ghz до 5,85ghz.

### Нюансы на камере

Для данной камеры существует два драйвера сенсора - "медленный" 1080p@30fps и "быстрый" 720p@50fps. Их можно переключать на ходу скриптами из примеров в [root](https://github.com/OpenIPC/sandbox-fpv/tree/master/gk7205v200/root), если залить на камеру ["быстрый" драйвер](https://github.com/OpenIPC/sandbox-fpv/blob/master/gk7205v200/lib/sensors/libsns_imx307_2l_720p.so) под отдельным именем и исправить к нему путь в его конфиге [`60fps/720p_imx307_i2c_2l.ini`](https://github.com/OpenIPC/sandbox-fpv/blob/master/gk7205v200/etc/sensors/60fps/720p_imx307_i2c_2l.ini#L15). Все файлы по данной камере находятся в каталоге `gk7205v200`. Если запускать камеру с "быстрым" драйвером в настройках majestic, то передача видео идет рывками, поэтому при старте камеры через `S95goke` прописываются настройки "медленного" драйвера, после чего уже можно включить "быстрый". На текущий момент ведется работа по управлению подобными настройками камеры через RC каналы в mavlink.

### Нюансы на регистраторе
Так как регистратор относительно камеры имеет шикарные 16мб памяти spi flash, из которых мы можем использовать около 5мб, то нам доступен [драйвер адаптеров RTL](https://github.com/OpenIPC/sandbox-fpv/tree/master/hi3536dv100/88XXau-ko) который поддерживает rtl8814au в дополнение к популярному rtl8812au. Для этого нужно залить его поверх штатного в `lib/modules/4.9.37/extra`, не забыв переименовать. Также изменен его запуск, `insmod` взамен `modprobe` в `S98wfb`. Там же изменен режим wfb-ng с передачи на прием (`wfb-rx`), в `wfb.conf` появился новый параметр `udp_addr` - это адрес, куда отправлять видеопоток. Все файлы можно увидеть [тут](https://github.com/OpenIPC/sandbox-fpv/tree/master/hi3536dv100).
Отключены сервисы `telnet`, `httpd`, `snmpd` как неиспользуемые через `exit 1` в [скриптах запуска](https://github.com/OpenIPC/sandbox-fpv/tree/master/hi3536dv100/etc/init.d).
Изменен и [запуск телеметрии](https://github.com/OpenIPC/sandbox-fpv/blob/master/hi3536dv100/usr/bin/telemetry), поскольку rx и tx части поменялись местами относительно "воздушной" части. Перекомпилирован [`mavlink-router`](https://github.com/OpenIPC/sandbox-fpv/tree/master/hi3536dv100/usr/bin), так как комплектный из прошивки собран на musl для воздушной части (где он не используется), а прошивка регистратора на glibc.

###  Нюансы телеметрии
Текущая схема работы телеметрии выглядит так:

![telemetry](https://github.com/OpenIPC/sandbox-fpv/raw/master/notes_files/telemetry.png)

С применением mavlink-routerd на текущий момент возможна только односторонняя телеметрия по udp, поскольку он не умеет использовать разные rx/tx udp порты в рамках одного endpoint, как того требует wfb-ng, будучи запущенным разными процессами `telemetry_rx` и `telemetry_tx`. Кстати, это просто символьные ссылки на wfb_rx и wfb_tx, создаваемые скриптом [запуска телеметрии](https://github.com/OpenIPC/sandbox-fpv/blob/master/hi3536dv100/usr/bin/telemetry). На текущий момент, для применения двусторонней телеметрии можно вернуть `mavfwd` взамен `mavlink-routerd` в скрипте запуска телеметрии `/usr/bin/telemetry`:
```
  #/usr/bin/mavlink-routerd -c /etc/mavlink.conf &
  /usr/sbin/mavfwd --master ${serial} --baudrate ${baud} --out 127.0.0.1:${port_tx} --in 127.0.0.1:${port_rx} &
```
Необходимо отключить ssh консоль от uart в /etc/inittab, закоменнтировав строчку:
```
#console::respawn:/sbin/getty -L  console 0 vt100 # GENERIC_SERIAL
```
Тогда телеметрия станет доступна на uart регистратора взамен udp по сети, и ее можно будет использовать через usb-uart адаптер как serial port.

Я скомпилировал `mavfwd` для регистратора, поддерживающий скорости b230400, b500000, b921600 и b1500000, для поддержки более высокой скорости при работе с Mission Planner, проверил на b500000 при b115200 / b230400 на камере. Для регистратора его можно забрать [здесь](https://github.com/OpenIPC/sandbox-fpv/tree/master/hi3536dv100/usr/sbin). Для камеры: [здесь](https://github.com/OpenIPC/sandbox-fpv/tree/master/gk7205v200/usr/sbin). На камере удалось получить устойчивую связь с полетником на скорости 230400, выше stm32f4 не смог.

Также я заложил в него основы для наблюдения за выбранными каналами RC mavlink и передачи их значений при изменении в `/root/channels.sh` как параметров $1 (канал) и $2 (значение).

##### продолжение следует
