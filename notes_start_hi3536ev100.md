### Заметки о прошивке NVR hi3536ev100 на OpenIPC для целей FPV

Для начала, следует разобраться, как устроена память регистратора (да и камеры тоже) и что нужно прошивать. Данные хранятся на spi-flash 16mb в виде блоков mtd:

```
cat /proc/cmdline
mem=150M console=ttyAMA0,115200 panic=20 root=/dev/mtdblock3 rootfstype=squashfs init=/init mtdparts=hi_sfc:256k(boot),64k(env),2048k(kernel),8192k(rootfs),-(rootfs_data)
ls /dev/mtdb*
/dev/mtdblock0  /dev/mtdblock1  /dev/mtdblock2  /dev/mtdblock3  /dev/mtdblock4
```
Как следует из вывода, нулевой блок это загрузчик u-boot; далее идет блок для хранения переменных окружения (`printenv`, `setenv` команды пишут в ОЗУ, а `saveenv` сохраняет именно в этот блок); следом ядро uImage; потом rootfs.squashfs (неизменяемый образ файловой системы); и наконец rootfs_data или он же overlay - изменяемая часть, куда пишутся отличия от rootfs если вы изменяете какие-либо файлы. Таким образом, очистив overlay, мы "скинем" файловую систему до "дефолта":
```
sf probe 0 #выбираем устройство
sf erase 0xA50000 0x500000 #производим очистку
reset #перезагрузка
```
Еще проще сбросить до "заводских" прошивки командой `firstboot`.

Калькулятор адресов для команд доступен [здесь](https://openipc.org/tools/firmware-partitions-calculation). В нашем случае раздел rootfs: 8192kB, значит адрес начала overlay будет 0xA50000. Для камеры, у которой flash 8mB, размер rootfs 5120kB, адреса будут другие, включая переменные окружения!


Загрузчик у этого регистратора не имеет пароля, и в него можно попасть через uart/115200 бод, нажав при старте несколько раз Ctrl+C. Значит, загрузчик мы шить не будем. Env у нас отличаются от заводских, но их проще установить прямо из загрузчика построчно:
```
setenv ipaddr '192.168.0.222' #тут ip в  вашей подсети из свободных
setenv serverip '192.168.0.107' #адрес ПК с tftp сервером
setenv netmask '255.255.255.0'
setenv bootcmd 'sf probe 0; sf read 0x82000000 0x50000 0x200000; bootm 0x82000000'
setenv uk 'mw.b 0x82000000 ff 1000000;tftp 0x82000000 uImage.${soc}; sf probe 0; sf erase 0x50000 0x200000; sf write 0x82000000 0x50000 ${filesize}'
setenv ur 'mw.b 0x82000000 ff 1000000;tftp 0x82000000 rootfs.squashfs.${soc}; sf probe 0; sf erase 0x250000 0x800000; sf write 0x82000000 0x250000 ${filesize}'
setenv bootargs 'mem=192M console=ttyAMA0,115200 panic=20 root=/dev/mtdblock3 rootfstype=squashfs init=/init mtdparts=hi_sfc:256k(boot),64k(env),2048k(kernel),8192k(rootfs),-(rootfs_data)'
setenv osmem '192M'
setenv totalmem '256M'
setenv soc 'hi3536dv100'
setenv da; setenv du; setenv dr; setenv dw; setenv dl; setenv dc; setenv up; setenv tk; setenv dd; setenv de; setenv jpeg_addr; setenv jpeg_size; setenv vobuf; setenv loadlogo; setenv appVideoStandard; setenv appSystemLanguage; setenv appCloudExAbility
saveenv #сохраняем новое окружение переменных
printenv #смотрим, все ли в порядке
```
Оригинальные env и полный дамп микросхемы (16mb) доступны [здесь](https://github.com/OpenIPC/sandbox-fpv/tree/master/hi3536dv100/original_firmware).

Как вы могли заметить, в переменных uk и ur хранятся макросы для прошивки [uImage](https://github.com/OpenIPC/sandbox-fpv/raw/master/hi3536dv100/uImage.hi3536dv100) и [rootfs.squash](https://github.com/OpenIPC/sandbox-fpv/raw/master/hi3536dv100/rootfs.squashfs.hi3536dv100) с загрузкой их с [tftp сервера](https://pjo2.github.io/tftpd64/), указанного в переменной serverip. Все адреса соответствуют переменной bootargs, содержимое которой и задает разметку файловой системы для ядра при загрузке. По ссылкам доступны ядро и rootfs, собранные мною, они включают в себя wfb; mavlink-routerd; zerotier, vtund. Однако, при сборке ([wiki](https://github.com/OpenIPC/wiki/blob/master/en/building.md)) туда включаются конфиги для "воздушной" части, поэтому [придется их перезаписать](hi3536dv100), это подробнее описано в [заметках о постройке линка](notes_link_gk7205v200_hi3536ev100.md).

Итак, после установки переменных можно приступать к прошивке оставшейся части. Запустите tftpd сервер, положите в его корень uImage.hi3536dv100 и rootfs.squashfs.hi3536dv100, выберите соответствующий сетевой интерфейс и в загрузчике запустите макрос: `run uk`. Должен выполниться ряд команд, из вывода которых должно следовать, что файл uImage скачался и прошился во flash. Аналогично выполните `run ur` для прошивки rootfs. Если адреса установлены верно, но скачивание застревает на "Downloading", смените адрес регистратора на соседний свободный: `setenv ipaddr '192.168.0.223'`.
Если все прошло без ошибок, делайте `reset` и грузитесь в операционную систему, логин root, без пароля. Первой командой выполните `firstboot`.

Далее залейте конфиги и исполняемые файлы через winscp ([etc / usr](https://github.com/OpenIPC/sandbox-fpv/tree/master/hi3536dv100)) и перезагрузите регистратор.

В дальнейшем прошивку регистратора можно делать, залив в него через WinSCP ядро и rootfs в каталог `/tmp` и выполнив `sysupgrade --kernel=/tmp/uImage.hi3536dv100 --rootfs=/tmp/rootfs.squashfs.hi3536dv100 -z`. Параметр `-z` нужен если у вас нет подключения к интернету (не обновляет скрипт sysupgrade), `-n` очистит пользовательскую fs (overlay).
