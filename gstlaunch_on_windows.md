## Прием и отображение видео на windows

В "классическом режиме" (на камере стримит majestic, а NVR пересылает видеопоток на ПК) видео можно принимать в QGroundControl, Mission Planner и можно просто вывести в отдельном окне
без привязки к программам. Для этого нужно установить [GStreamer](https://gstreamer.freedesktop.org/download/) и запускать его на прием с некими параметрами, например:
```
C:\gstreamer\1.0\msvc_x86_64\bin\gst-launch-1.0.exe -v udpsrc port=5600 buffer-size=90000 ! application/x-rtp ! rtph265depay ! avdec_h265 ! videoconvert ! videoscale ! video/x-raw,width=1280,height=720,format=BGRA ! autovideosink sync=false
```

В данном примере размер видео изменяется до 1280x720. Для запуска видео с разрешением оригинального потока убираем из строки `videoscale ! ` и `width=1280,height=720,`.


![preview](https://github.com/OpenIPC/sandbox-fpv/raw/master/notes_files/Screenshot_2.png)
