yaml-cli -s .isp.sensorConfig /etc/sensors/imx307_i2c_2l_1080p.ini
#yaml-cli -s .video0.bitrate 12288
#yaml-cli -s .video0.bitrate 7168
yaml-cli -s .video0.bitrate 3072
yaml-cli -s .video0.size 1920x1080
yaml-cli -s .video0.fps 30
yaml-cli -s .video0.crop 0x0x1920x1080
sleep .2
/root/kill.sh
