#include "sbus.h"
#include <JoystickMHX.h>

//#define SERIAL_DEBUG

//SBUS part
bfs::SbusRx sbus_rx(&Serial1);
bfs::SbusData sbus;
//Joystic part
Joystick_ Joystick(JOYSTICK_DEFAULT_REPORT_ID,JOYSTICK_TYPE_JOYSTICK,
  32, 2,                  // Button Count, Hat Switch Count
  true, true, true,     // X and Y, Z Axis
  true, true, true,   // Rx, Ry,  Rz
  true, true, true, true,  // slider, dial, rudder and throttle
  false, false, false);  // accelerator, brake, and steering



void setup() {
  #ifdef SERIAL_DEBUG
  Serial.begin(115200);
  while (!Serial) {}
  Serial.println("Started");
  #else
  Joystick.begin();
  //range
  Joystick.setXAxisRange(0, 2000);
  Joystick.setYAxisRange(0, 2000);
  Joystick.setZAxisRange(0, 2000);
  Joystick.setRxAxisRange(0, 2000);
  Joystick.setRyAxisRange(0, 2000);
  Joystick.setRzAxisRange(0, 2000);
  Joystick.setSliderRange(0, 2000);
  Joystick.setDialRange(0, 2000);
  Joystick.setRudderRange(0, 2000);
  Joystick.setThrottleRange(0, 2000);
  //default
  Joystick.setRudder(1500);
  Joystick.setAccelerator(0);
  Joystick.setBrake(1500);
  Joystick.setSteering(1500);
  #endif
  sbus_rx.Begin();
}

void loop() {
  if (sbus_rx.Read()) {
     sbus = sbus_rx.data();
     
     for(uint8_t i=0; i <  sbus.NUM_CH; i++) {
        sbus.ch[i] = map(sbus.ch[i], 150, 1850, 0, 2000); 
        #ifdef SERIAL_DEBUG
        Serial.print(sbus.ch[i]);
        Serial.print("\t");
        #endif
     }
     
     #ifdef SERIAL_DEBUG
     Serial.println();
     #else
     Joystick.setXAxis    (sbus.ch[0]);
     Joystick.setYAxis    (sbus.ch[1]);
     Joystick.setZAxis    (sbus.ch[2]);
     Joystick.setRxAxis   (sbus.ch[3]);
     Joystick.setRyAxis   (sbus.ch[4]);
     Joystick.setRzAxis   (sbus.ch[5]);
     Joystick.setSlider   (sbus.ch[6]);
     Joystick.setRudder   (sbus.ch[7]);
     Joystick.setThrottle (sbus.ch[8]);
     Joystick.setDial     (sbus.ch[9]);
     if(sbus.ch[10] > 1490) Joystick.setButton(0, 255);
     if(sbus.ch[11] > 1490) Joystick.setButton(1, 255);
     if(sbus.ch[12] > 1490) Joystick.setButton(2, 255);
     if(sbus.ch[13] > 1490) Joystick.setButton(3, 255);
     if(sbus.ch[14] > 1490) Joystick.setButton(4, 255);
     Joystick.sendState();
     delay(1);
     #endif
  }
}
