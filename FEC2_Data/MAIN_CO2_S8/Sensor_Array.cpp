#include "application.h"
#include "Sensor_Array.h"
//#include "Particle.h"
Sensor_Array::Sensor_Array(){}

void Sensor_Array::channel0(){
	
	//Serial.println("Channel 0");
	pinMode(WKP,OUTPUT);
	digitalWrite(WKP, LOW);
	pinMode(D6,OUTPUT);
	pinMode(D7,OUTPUT);
	digitalWrite(D6,LOW);
	digitalWrite(D7,LOW);
	
}

void Sensor_Array::channel1(){
	
	//Serial.println("Channel 1");
	pinMode(WKP,OUTPUT);
	digitalWrite(WKP, LOW);
	pinMode(D6,OUTPUT);
	pinMode(D7,OUTPUT);
	digitalWrite(D6,HIGH);
	digitalWrite(D7,LOW);
	
}

void Sensor_Array::channel2(){
	
	//Serial.println("Channel 2");
	pinMode(WKP,OUTPUT);
	digitalWrite(WKP, LOW);
	pinMode(D6,OUTPUT);
	pinMode(D7,OUTPUT);
	digitalWrite(D6,LOW);
	digitalWrite(D7,HIGH);
	
}


void Sensor_Array::channel3(){
	
	//Serial.println("Channel 3");
	pinMode(WKP,OUTPUT);
	digitalWrite(WKP, LOW);
	pinMode(D6,OUTPUT);
	pinMode(D7,OUTPUT);
	digitalWrite(D6,HIGH);
	digitalWrite(D7,HIGH);
	
}


