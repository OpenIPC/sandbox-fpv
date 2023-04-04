## Подключение планшета или телефона по usb-ethernet устройству.

Устройство являет собой сетевую карту, подключаемую по usb к планшету, и выглядит примерно так:

![usb-ethernet.png](https://github.com/OpenIPC/sandbox-fpv/raw/master/notes_files/usb-ethernet.png)

Оно подключается к регистратору посредством ethernet-кабеля, после чего в [`/etc/wfb.conf`](hi3536dv100/etc/wfb.conf) указывается `udp_addr=auto` взамен фиксированного адреса. На самом планшете нужно включить функцию "Ethernet-modem"
в настройках "Сеть и интернет > Точка доступа и модем".

Далее все сделает сервис [`/usr/bin/wifibroadcast`](hi3536dv100/usr/bin/wifibroadcast) при загрузке регистратора или перезапуске с [front-panel](nvr_gpio.md).
