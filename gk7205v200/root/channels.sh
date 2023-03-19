echo $1 $2 >>/tmp/channels.log

#channel 5
if [ $1 -eq 5 ]; then
    if [ $2 -lt 1500 ]; then
      /root/1080.sh
    else
      /root/720.sh
    fi
fi

exit 1