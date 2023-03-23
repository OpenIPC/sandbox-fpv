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

function set_gpio {
  echo $2 > /sys/class/gpio/gpio$1/value
}

function get_gpio {
  cat /sys/class/gpio/gpio${1}/value
}

#for i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
#do
#  gpio_setup $i in
#  echo $i: `get_gpio $i`
#done

gpio_setup 10 out
set_gpio 10 1
sleep 5
#set_gpio 10 0
