### Заметки о прошивке NVR hi3536ev100 на OpenIPC для целей FPV

Для начала, следует разобраться, как устроена память регистратора и что нужно прошивать. Данные хранятся на spi-flash 16mb в виде блоков mtd:

```
cat /proc/cmdline
mem=150M console=ttyAMA0,115200 panic=20 root=/dev/mtdblock3 rootfstype=squashfs init=/init *mtdparts=hi_sfc:256k(boot),64k(env),2048k(kernel),8192k(rootfs),-(rootfs_data)*
ls /dev/mtdb*
/dev/mtdblock0  /dev/mtdblock1  /dev/mtdblock2  /dev/mtdblock3  /dev/mtdblock4
```
Как следует из вывода, нулевой блок это загрузчик u-boot; далее идет блок для хранения переменных окружения (`printenv`, `setenv` команды пишут в ОЗУ, а `saveenv` сохраняет именно в этот блок); следом ядро uImage; потом rootfs.squashfs (неизменяемый образ файловой системы); и наконец rootfs_data или он же overlay - изменяемая часть, куда пишутся отличия от rootfs если вы изменяете какие-либо файлы. Таким образом, очистив overlay, мы "скинем" файловую систему до "дефолта".


