## Подключение планшета к регистратору по wifi через AP планшета

Схема проста: в регистратор вставляется [TL-725n](https://www.tp-link.com/ru/home-networking/adapter/tl-wn725n/) или аналогичный адаптер на rtp8188eu, либо адаптер под
который есть драйвер для у OpenIPC; планшет включает точку доступа; регистратор коннектится к этой точке доступа; при перезапуске сервис wfb обнаруживает указанный wlan и
настраивает трансляцию и телеметрию на планшет.

### Поднимем сеть
* Закачаем драйвер [8188eu](hi3536dv100/lib/modules/4.9.37/extra/8188eu.ko) в `/lib/modules/4.9.37/extra/`
* Настроим поднятие сети на адаптере в [`/etc/network/interfaces`](hi3536dv100/etc/network/interfaces), указывая свои ssid и password:
```
      auto wlan1
      iface wlan1 inet dhcp
          pre-up insmod /lib/modules/4.9.37/extra/8188eu.ko
          pre-up sleep 1
          pre-up wpa_passphrase "ssid" "password" >/tmp/wpa_supplicant.conf
          pre-up sed -i '2i \\tscan_ssid=1' /tmp/wpa_supplicant.conf
          pre-up sleep 3
          pre-up wpa_supplicant -B -D nl80211 -i wlan1 -c/tmp/wpa_supplicant.conf
          post-down killall -q wpa_supplicant
```
### Поправим конфиги сервисы
* Зальем обновленные [`S98wfb`](hi3536dv100/etc/init.d/S98wfb) и [`telemetry`](hi3536dv100/usr/bin/telemetry) в /etc/init.d и /usr/bin.
* Добавим в [wfb.conf](hi3536dv100/etc/wfb.conf) новую строчку с параметром - наименованием интерфейса для ap
```
tab_wlan=wlan1
```
* Если мы не пользуемся отправкой потока на PC, можно закомментировать параметр `udp_addr`, это немного разгрузит регистратор.
* Включаем на планшете точку доступа и перезагружаем регистратор.
