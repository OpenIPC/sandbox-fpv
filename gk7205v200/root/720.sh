yaml-cli -s .isp.sensorConfig /etc/sensors/imx307_i2c_2l_720p_50fps.ini
yaml-cli -s .video0.size 1280x720
yaml-cli -s .video0.fps 50
sleep .2
killall -1 majestic
sleep .2
