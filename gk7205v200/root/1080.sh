yaml-cli -s .isp.sensorConfig /etc/sensors/imx307_i2c_2l_1080p.ini
yaml-cli -s .video0.size 1920x1080
yaml-cli -s .video0.fps 30
sleep .5
killall -1 majestic
sleep .5
