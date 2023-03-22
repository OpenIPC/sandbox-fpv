## Подключение смартфона или планшета на android для FPV-VR и прочих программ GS к NVR.

USB Tethering, он же USB Ethernet - функция ОС Android для использования телефона в качестве USB-модема, представляющегося сетевой картой. Нам это дает возможность соединить
телефон и NVR обычным usb-проводом и получить между ними быструю сеть.

Нужно [установить](notes_start_hi3536ev100.md) [ядро](hi3536dv100/uImage.hi3536dv100) и [rootfs](hi3536dv100/rootfs.squashfs.hi3536dv100) с поддержкой rndis_host и залить [S98wfb](hi3536dv100/etc/init.d/S98wfb), [telemetry](hi3536dv100/usr/bin/telemetry), и добавить в [interfaces](hi3536dv100/etc/network/interfaces) следующее:
```
#USB Tethering
auto usb0
iface usb0 inet dhcp
    pre-up modprobe rndis_host
    pre-up sleep 4
```

