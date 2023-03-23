## Отключение watchdog на регистраторе

Загрузчик на регистраторе запускает собаку, которая раз в полчаса перезагружает его. Для отключения копируем [`wdt.ko`](hi3536dv100/lib/wdt.ko) в `/lib` и создаем в /etc/init.d файл [`S91wdt`](hi3536dv100/etc/init.d/S91wdt):
```
#!/bin/sh
#
# disable hisilicon watchdog
#

case "$1" in
  start)
    echo "Disabling watchdog..."
    insmod /lib/wdt.ko
    rmmod /lib/wdt.ko
    ;;
  stop)
    echo "Not need any action..."
    ;;
    *)
    echo "Usage: $0 {start|stop}"
    exit 1
esac
```

Перезагружаемся, watchdog больше не должен срабатывать.
