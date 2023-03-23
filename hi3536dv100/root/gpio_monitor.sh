##IR 
##Y2 !17
##Y1 !6
##X2 !13
##Y3 !8
##X1 !7
##ALARM 10
##REC 11

function gpio_setup {
  if [ ! -e /sys/class/gpio/gpio$1 ]; then
    echo $1 > /sys/class/gpio/export
  fi
  echo $2 > /sys/class/gpio/gpio$1/direction
}

function set_gpio {
  echo $2 > /sys/class/gpio/gpio$1/value
}


function get_gpio {
  return `cat /sys/class/gpio/gpio${1}/value`
}

#buttons
for i in 6 7 8 13 17
do
  gpio_setup $i in
done

#ALARM led
gpio_setup 10 out

while [ true ]
do
  get_gpio 6
  if [ "$?" -eq 0 ]; then
      echo 6 >>/tmp/gpio.log
      set_gpio 10 1
      ifdown usb0
      ifup usb0
      sleep .1
      /etc/init.d/S98wfb stop
      sleep .1
      /etc/init.d/S98wfb start
      sleep .5
      set_gpio 10 0
  fi
  
  get_gpio 7
  if [ "$?" -eq 0 ]; then
      echo 7 >>/tmp/gpio.log
      sleep .5
  fi
  
  get_gpio 8
  if [ "$?" -eq 0 ]; then
      echo 8 >>/tmp/gpio.log
      sleep .5
  fi
  
  get_gpio 13
  if [ "$?" -eq 0 ]; then
      echo 13 >>/tmp/gpio.log
      sleep .5
  fi
  
  get_gpio 16
  if [ "$?" -eq 1 ]; then
      echo 16 >>/tmp/gpio.log
      sleep .5
  fi
  
  get_gpio 17
  if [ "$?" -eq 0 ]; then
      echo 17 >>/tmp/gpio.log
      sleep .5
  fi
  
  get_gpio 40
  if [ "$?" -eq 1 ]; then
      echo 40 >>/tmp/gpio.log
      sleep .5
  fi
  sleep .1
done
