# sandbox-fpv
Sandbox for FPV experiments. Telegram-group: `https://t.me/+BMyMoolVOpkzNWUy` | [link](https://t.me/+BMyMoolVOpkzNWUy)

В связи с некоторыми обстоятельствами, wfb-ng был заменен в моих камере и регистраторе на альтернативу от OpenHD. [В архиве](wfbopenhd.zip) пакет для сборки в buildroot OpenIPC. В шелл-обертках учтены оба варианта, по наличию параметра `link_id`, [архив](https://github.com/OpenIPC/sandbox-fpv/blob/master/wfb.zip) с бинарниками обоих вариантов.

* [Заметки о настройке линка на камере gk7205v200 и регистраторе hi3536ev100 (dv100)](notes_link_gk7205v200_hi3536ev100.md)
* [Заметки о прошивке камеры gk7205v200 на OpenIPC](notes_start_ivg-g2s.md)
* [Заметки о прошивке регистратора hi3536ev100 на OpenIPC](notes_start_hi3536ev100.md)
* [Заметка о управлении камерой через RC каналы с наземки](notes_cam_control.md)
* [Загрузчик под телеметрию для gk7502v200, который не вешает камеру при ребуте](gk7205v200_u-boot-7502v200-for-telemetry.md)
* [Управление кнопками с front panel на регистраторе](nvr_gpio.md)
* [Подключение и настройка планшета или смартфона для видео и OSD по USB](usb-tethering.md)
* [Подключение планшета к регистратору по wifi через AP планшета](note-nvr-tab-ap.md)
* [Использование аппаратуры как джойстика для передачи каналов RC через mavlink](rcjoystick.md)
* [SBUS-to-USB joystick для использования любой аппаратуры с sbus приемником](sbus-to-usb-joystick)
* [Установка usb_modeswitch на камеру с прошивкой fpv, lite](usb-modeswitch.md)

#### Разное
* [mavfwd для inav (односторонний msp) для камеры](user_TipoMan/mavfwd_mavlink2.tar?raw=true)
* [Отображение видео на windows и в MP](gstlaunch_on_windows.md)
* [Отключение watchdog на регистраторе hi3536dv100](note_nvr_wdt.md)

### Дорожная карта
* ~~Запуск видео с передачей с регистратора на пк.~~
* ~~Запуск одно-и двусторонней телеметрии.~~
* ~~Запуск передачи видео через usb tethering на android-планшет.~~
* Сборка и тестирование прошивки LTE на e3372h + zerotier
* ~~Запуск маршрутизации телеметрии через mavlink-router.~~
* Поиск путей управления камерой сквозь wfb-ng.
* Поиск способов вывода видео и osd через hdmi.
* Переключение между несколькими камерами, где одна ведущая с wfb-ng, а остальные ведомые.
* Разработка платы расширения для камеры: bec 5v/3.3v; usb hub, uart, транзистор питания wifi/modem, microSD.
* Разработка платы управления зум-объективом и способа управления имеющимися в продаже платами.
* Разработка стабилизирующего подвеса, управляемого с земли сквозь wfb-ng.
