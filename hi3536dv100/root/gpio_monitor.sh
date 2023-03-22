##IR 
##Y2 !17
##Y1 !6
##X2 !13
##Y3 !8
##X1 !7
##ALARM 40
##REC 16

function gpio_setup {
  if [ ! -e /sys/class/gpio/gpio$1 ]; then
    echo $1 > /sys/class/gpio/export
  fi
  echo $2 > /sys/class/gpio/gpio$1/direction
}

function get_gpio {
  return `cat /sys/class/gpio/gpio${1}/value`
}

for i in 6 7 8 13 16 17 40
do
  gpio_setup $i in
done

while [ true ]
do
  get_gpio 6
  if [ "$?" -eq 0 ]; then
      echo 6
      sleep .5
  fi
  
  get_gpio 7
  if [ "$?" -eq 0 ]; then
      echo 7
      sleep .5
  fi
  
  get_gpio 8
  if [ "$?" -eq 0 ]; then
      echo 8
      sleep .5
  fi
  
  get_gpio 13
  if [ "$?" -eq 0 ]; then
      echo 13
      sleep .5
  fi
  
  get_gpio 16
  if [ "$?" -eq 1 ]; then
      echo 16
      sleep .5
  fi
  
  get_gpio 17
  if [ "$?" -eq 0 ]; then
      echo 17
      sleep .5
  fi
  
  get_gpio 40
  if [ "$?" -eq 1 ]; then
      echo 40
      sleep .5
  fi
  sleep .1
done