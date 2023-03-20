## U-Boot для телеметрии

Чтобы поток телеметрии не прерывал загрузку камеры, когда u-boot считает телеметрию "нажатием любой кнопки для входа в консоль загрузчика", нужно залить этот загрузчик:
[ССЫЛКА](https://github.com/OpenIPC/sandbox-fpv/raw/master/gk7205v200/u-boot-gk7205v200-universal.bin):
```
# закачайте файл u-boot-gk7205v200-universal.bin в /tmp камеры через winscp ИЛИ выполните команду и УБЕДИТЕСЬ ЧТО ФАЙЛ СКАЧАЛСЯ!!!
#curl -o /tmp/u-boot-gk7205v200-universal.bin http://fpv.openipc.net/u-boot-gk7205v200-universal.bin
flashcp -v /tmp/u-boot-gk7205v200-universal.bin /dev/mtd0
```

Данный загрузчик прерывается по комбинации клавиш Ctrl+C, а не любой.
