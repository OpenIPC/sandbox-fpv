###  Установка usb_modeswitch на камеру с прошивкой fpv, lite
```
curl -o /usr/sbin/usb_modeswitch https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/usb_modeswitch && chmod +x /usr/sbin/usb_modeswitch
curl -o /usr/sbin/usb_modeswitch_dispatcher https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/usb_modeswitch_dispatcher && chmod +x /usr/sbin/usb_modeswitch_dispatcher
curl -o /etc/usb_modeswitch.conf https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/usb_modeswitch.conf
curl -o /usr/lib/libusb-1.0.so.0.3.0 https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/libusb-1.0.so.0.3.0 && chmod +x /usr/lib/libusb-1.0.so.0.3.0
ln -s -f /usr/lib/libusb-1.0.so.0.3.0 /usr/lib/libusb-1.0.so
ln -s -f /usr/lib/libusb-1.0.so.0.3.0 /usr/lib/libusb-1.0.so.0
mkdir -p /usr/include/libusb-1.0 && curl -o /usr/include/libusb-1.0/libusb.h https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/libusb.h
```

Проверяем с модемом e3372h.
```
usb_modeswitch -v 0x12d1 -p 0x1f01 -J

Look for default devices ...
 Found devices in default mode (1)
Access device 002 on bus 001
Get the current device configuration ...
Current configuration number is 1
Use interface number 0
 with class 8
Use endpoints 0x01 (out) and 0x81 (in)
Using standard Huawei switching message
Looking for active drivers ...
Set up interface 0
Use endpoint 0x01 for message sending ...
Trying to send message 1 to endpoint 0x01 ...
 OK, message successfully sent
Read the response to message 1 (CSW) ...
 Device seems to have vanished after reading. Good.
 Device is gone, skip any further commands
-> Run lsusb to note any changes. Bye!
```
```
lsusb
Bus 001 Device 001: ID 1d6b:0002
Bus 001 Device 003: ID 12d1:14dc
Bus 002 Device 001: ID 1d6b:0003
```
12d1:14dc и есть наш CDC Ethernet девайс.

```
modprobe usbserial vendor=0x12d1 product=0x14dc
modprobe rndis_host
ip a

3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
    link/ether 0c:5b:8f:27:9a:64 brd ff:ff:ff:ff:ff:ff
```

Наша сетевая готова! Можем пробовать вставлять сим. Пример настройки для автоматизации запуска в /etc/network/interfaces для e3372h:
```
auto eth1
iface eth1 inet dhcp
    pre-up sleep 4
    pre-up usb_modeswitch -v 0x12d1 -p 0x1f01 -J
    pre-up modprobe usbserial vendor=0x12d1 product=0x14dc
    pre-up modprobe rndis_host
    pre-up sleep 4
```
