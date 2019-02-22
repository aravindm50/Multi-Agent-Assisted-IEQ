/* CO2 Sensair_S8 sensor library
Author: Aravind Madan Mohan
Project: GBIC
NATIONAL UNIVERSITY OF SINGAPORE*/

#include "application.h"
#include "S8.h"

/* byte co2cmd[] = {
  0xFE,
  0X44,
  0X00,
  0X08,
  0X02,
  0X9F,
  0X25
};
 */
 
// Byte to send to get CO2 output from Sensair S8 sensor 
byte co2cmd[] = {
  0xFE,
  0X04,
  0X00,
  0X03,
  0X00,
  0X01,
  0XD5,
  0XC5
};

S8::S8(){}

int S8::value() {
	
	// byte to store the received output
	byte co2res[] = { 0, 0, 0, 0, 0, 0, 0 };
	int co2 = 0;
	unsigned long time = millis();
	int e = 0;
	
	// Avaeraging output for 10 second intervval
	while(millis() - time < 10000){
		
		while( !Serial1.available() ) {
			Serial1.write(co2cmd, 8); // Send when serial available
			delay(50);
		}

		int timeout=0;
		while( Serial1.available() < 7 ) {
			timeout++;
			if(timeout > 10) {
			  while(Serial1.available()) Serial1.read();
			  break;
			}
			delay(500);
		}

		for (int i = 0; i < 7; i++) {
			co2res[i] = Serial1.read();   // read CO2 data from sensor 
		}
		
		if (co2res[3] != 0xFF && co2res[4] != 0xFF)
		{	
			int high          = co2res[3]; 	// 3rd bit with higher order CO2 reading
			int low           = co2res[4];	// 4th bit with lower order CO2 reading
			
			//Bit conversion from Hexadecimal to decimal
			int a = high%10; 
			int b = high/10;
			int c = low%10;
			int d = low/10;
			co2 = co2 + a*256+d*16 + c;
			
		}
		e = e+1;
	
	}
	
	float co2_ave = co2/e; // Average for the time period
	if (co2_ave >= 400) // Output values above 400 as indoor value always above 400
	{
		return co2_ave;
	}
}	