echo $1 $2 >>/tmp/channels.log

#channel 5
if [ $1 -eq 5 ]; then
    if [ $2 -gt 1600 ]; then
      CURRENT_SIZE=`yaml-cli -g .video0.size`
      if [ $CURRENT_SIZE == '1280x720' ]; then
        /root/1080.sh
        sleep 3
      else
        /root/720.sh
        sleep 3
      fi
    fi
fi

#channel 6
if [ $1 -eq 6 ]; then
    if [ $2 -lt 1600 ]; then
      /root/ircut.sh off
    else
      /root/ircut.sh on
    fi
fi

#channel 7
if [ $1 -eq 7 ]; then
    if [ $2 -lt 1400 ]; then
      yaml-cli -s .image.luminance 50
      killall -1 majestic
    elif [ $2 -gt 1400 ] && [ $2 -lt 1600 ]; then
      yaml-cli -s .image.luminance 90
      killall -1 majestic
    else
      yaml-cli -s .image.luminance 30
      killall -1 majestic
    fi
fi

#channel 8
if [ $1 -eq 8 ]; then
    if [ $2 -gt 1600 ]; then
      CURRENT_BITRATE=`yaml-cli -g .video0.bitrate`
      if [ $CURRENT_BITRATE -lt 7168 ]; then
        NEW_BITRATE="$(($CURRENT_BITRATE+1024))"
      else
        NEW_BITRATE="1024"
        sleep 2
      fi
      yaml-cli -s .video0.bitrate $NEW_BITRATE
      sleep .2
      /root/kill.sh
    fi
    sleep 3
fi

exit 1
