###  Установка usb_modeswitch на камеру с прошивкой fpv, lite
```
#install usb_modeswitch
curl -o /usr/bin/jimsh https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/jimsh && chmod +x /usr/bin/jimsh
curl -o /usr/sbin/usb_modeswitch https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/usb_modeswitch && chmod +x /usr/sbin/usb_modeswitch
curl -o /usr/sbin/usb_modeswitch_dispatcher https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/usb_modeswitch_dispatcher && chmod +x /usr/sbin/usb_modeswitch_dispatcher
curl -o /etc/usb_modeswitch.conf https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/usb_modeswitch.conf
curl -o /lib/udev/usb_modeswitch https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/usb_modeswitch.sh && chmod +x /lib/udev/usb_modeswitch
curl -o /usr/lib/libusb-1.0.so.0.3.0 https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/libusb-1.0.so.0.3.0 && chmod +x /usr/lib/libusb-1.0.so.0.3.0
ln -s -f /usr/lib/libusb-1.0.so.0.3.0 /usr/lib/libusb-1.0.so
curl -o /usr/lib/libjim.so.0.79 https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/libjim.so.0.79 && chmod +x /usr/lib/libjim.so.0.79
mkdir -p /usr/include/libusb-1.0 && curl -o /usr/include/libusb-1.0/libusb.h https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/libusb.h

#install usb_modeswitch_data
curl -o /tmp/usb_modeswitch_data.tar https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/data/usb_modeswitch_data.tar && tar -xf /tmp/usb_modeswitch_data.tar -C /usr/share/
mkdir -p /lib/udev/rules.d && curl -o /lib/udev/rules.d/40-usb_modeswitch.rules https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/data/40-usb_modeswitch.rules

```

Пример настройки в /etc/network/interfaces для e3372h:
```
auto eth1
iface eth1 inet dhcp
    pre-up sleep 4
    pre-up usb_modeswitch -v 0x12d1 -p 0x1f01 -J
    pre-up modprobe usbserial vendor=0x12d1 product=0x14dc
    pre-up modprobe rndis_host
    pre-up sleep 4
```
