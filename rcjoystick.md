## Использование аппаратуры как джойстика для передачи каналов RC через mavlink

### Теория
Программы наземных станций, такие как Mission Planner или QGroundControl, способны распознавать подключенные джойстики либо аппаратуры в режиме usb-джойстика и
передавать на полетный контроллер значения осей в пакете RC_CHANNELS_OVERRIDE (#70). Однако, QGC передает только первые 4 канала (две оси), остальное можно назначить только на кнопки,
а MP может это делать только под Windows, что не всегда удобно. Я написал простейшее приложение для регистратора, которое распознает подключенный джойстик и отправляет пакеты [RC_CHANNELS_OVERRIDE](https://mavlink.io/en/messages/common.html#RC_CHANNELS_OVERRIDE) напрямую в порт telemetry_tx, который обычно опубликован на 127.0.0.1:14650. Порт, адрес, время между отправками пакетов, число осей и устройство в системе можно переназначить, смотрите `rcjoystick -h`.

```
Usage:
 [-v] verbose;
 [-d device] default '/dev/input/js0';
 [-a addr] ip address send to, default 127.0.0.1;
 [-p port] udp port send to, default 14650;
 [-t time] update RC_CHANNEL_OVERRIDE time in ms, default 50;
 [-x axes_count] 2..9 axes, default 5, other channels mapping to js buttons from button 0;
```

Например, отправлять можно не в telemetry_tx, а в mavlink_routerd, если вам так нужно. Пакет для сборки в buildroot от OpenIPC [тут](rcjoystick).

### Запускаем
Нам необходимо ядро и rootfs с поддержкой usb-hid. Для этого [прошейте](notes_start_hi3536ev100) их из [`/hi3536dv100`](hi3536dv100) каталога.
Необходимо обеспечить запуск модуля `hid-generic.ko`, для этого добавьте `modprobe hid-generic.ko` в [`S95hisilicon`](hi3536dv100/etc/init.d/S95hisilicon).

Далее нужно скопировать бинарник [`rcjoystick`](hi3536dv100/usr/bin/rcjoystick) в /usr/bin регистратора, через WinSCP и назначить права на исполнение: `chmod +x /usr/bin/rcjoystick`.
Перезагружаемся, подключаем аппаратуру к регистратору по usb и пробуем в консоли запустить `rcjoystick -v`. Если все прошло хорошо, то на экране мы должны увидеть значения осей при изменении положения стиков и переключателей, а в программе телеметрии, например в QGC (analyse tools > Mavlink inspector > RC_CHANNELS_RAW) должны изменяться каналы. Для запуска на постоянную можно прописать его например в S95hisilicon как `/usr/bin/rcjoystick -t 25 &>/dev/null`.

Проект пока в стадии тестирования, поэтому [присылайте](https://t.me/+BMyMoolVOpkzNWUy) свои отзывы о попытках и пожелания.
