yaml-cli -s .isp.sensorConfig /etc/sensors/60fps/720p_imx307_i2c_2l.ini
yaml-cli -s .video0.size 1280x720
yaml-cli -s .video0.fps 50
sleep .5
killall -1 majestic
sleep .5
