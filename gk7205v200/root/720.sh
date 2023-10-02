yaml-cli -s .isp.sensorConfig /etc/sensors/720p30_imx307_50.ini
#yaml-cli -s .video0.bitrate 12288
#yaml-cli -s .video0.bitrate 7168
yaml-cli -s .video0.bitrate 3072
yaml-cli -s .video0.size 1280x720
yaml-cli -s .video0.fps 50
yaml-cli -s .video0.crop 0x0x1280x720
sleep .2
/root/kill.sh
