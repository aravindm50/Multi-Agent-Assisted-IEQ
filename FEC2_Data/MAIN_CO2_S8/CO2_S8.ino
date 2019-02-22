#include "Sensor_Array.h"
#include "S8.h"
unsigned long s8_co2;
Sensor_Array abc; // initialize sensor array
S8 co2; // initialize co2 sensor


void setup()   {
 
  Serial.begin(9600);
  abc.channel0(); // initialize channel of CO2 sensor in sensor array
  Serial1.begin(9600);
  delay(2000);
}


void loop() {
	
	s8_co2 = co2.value(); //get co2 value
	Serial.println(s8_co2); // print co2 value
}


