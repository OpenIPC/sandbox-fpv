###  Установка usb_modeswitch на камеру с прошивкой fpv, lite

Проверяем с модемом e3372h.

```
ntpd -Nnq
curl -o /usr/sbin/usb_modeswitch https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/usb_modeswitch && chmod +x /usr/sbin/usb_modeswitch
###curl -o /usr/sbin/usb_modeswitch_dispatcher https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/usb_modeswitch_dispatcher && chmod +x /usr/sbin/usb_modeswitch_dispatcher
###curl -o /etc/usb_modeswitch.conf https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/usb_modeswitch.conf
curl -o /usr/lib/libusb-1.0.so.0.3.0 https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/libusb-1.0.so.0.3.0 && chmod +x /usr/lib/libusb-1.0.so.0.3.0
ln -s -f /usr/lib/libusb-1.0.so.0.3.0 /usr/lib/libusb-1.0.so
ln -s -f /usr/lib/libusb-1.0.so.0.3.0 /usr/lib/libusb-1.0.so.0
curl -o /tmp/usb_modeswitch.tar https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/usb_modeswitch.tar && tar -xvf /tmp/usb_modeswitch.tar -C /usr/share/
```

```
curl -o /usr/sbin/usb_modeswitch http://ubuntu.vmclouds.ru/files/usb-modeswitch/musl/usb_modeswitch && chmod +x /usr/sbin/usb_modeswitch
###curl -o /usr/sbin/usb_modeswitch_dispatcher http://ubuntu.vmclouds.ru/files/usb-modeswitch/musl/usb_modeswitch_dispatcher && chmod +x /usr/sbin/usb_modeswitch_dispatcher
###curl -o /etc/usb_modeswitch.conf http://ubuntu.vmclouds.ru/files/usb-modeswitch/musl/usb_modeswitch.conf
curl -o /usr/lib/libusb-1.0.so.0.3.0 http://ubuntu.vmclouds.ru/files/usb-modeswitch/musl/libusb-1.0.so.0.3.0 && chmod +x /usr/lib/libusb-1.0.so.0.3.0
ln -s -f /usr/lib/libusb-1.0.so.0.3.0 /usr/lib/libusb-1.0.so
ln -s -f /usr/lib/libusb-1.0.so.0.3.0 /usr/lib/libusb-1.0.so.0
curl -o /tmp/usb_modeswitch.tar http://ubuntu.vmclouds.ru/files/usb-modeswitch/musl/usb_modeswitch.tar && tar -xvf /tmp/usb_modeswitch.tar -C /usr/share/
```

Вносим этот блок для e3372h в /etc/network/interfaces:
```
manual eth1
iface eth1 inet dhcp
    pre-up sleep 4
    pre-up usb_modeswitch -v 0x12d1 -p 0x1f01 -J
    pre-up modprobe usbserial vendor=0x12d1 product=0x14dc
    pre-up modprobe rndis_host
    pre-up sleep 4
```

Передергиваем модем, пробуем `ifup eth1`. Если сетевая поднялась, в interfaces можем manual заменить на auto. 
