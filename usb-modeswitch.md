###  Установка usb_modeswitch на камеру с прошивкой fpv, lite
```
curl -o /usr/sbin/usb_modeswitch https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/usb_modeswitch && chmod +x /usr/sbin/usb_modeswitch
curl -o /usr/sbin/usb_modeswitch_dispatcher https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/usb_modeswitch_dispatcher && chmod +x /usr/sbin/usb_modeswitch_dispatcher
curl -o /etc/usb_modeswitch.conf https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/usb_modeswitch.conf
curl -o /usr/lib/libusb-1.0.so.0.3.0 https://github.com/OpenIPC/sandbox-fpv/raw/master/usb-modeswitch/musl/libusb-1.0.so.0.3.0 && chmod +x /usr/lib/libusb-1.0.so.0.3.0
ln -s /usr/lib/libusb-1.0.so.0.3.0 /usr/lib/libusb-1.0.so
```
