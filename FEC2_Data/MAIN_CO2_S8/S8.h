/* CO2 Sensair_S8 sensor library
Author: Aravind Madan Mohan
Project: GBIC
NATIONAL UNIVERSITY OF SINGAPORE*/

#include "application.h"
#ifndef __S8_H_
#define __S8_H_
#include <Particle.h>


class S8
{
	public:
		S8();
		int value();	
		
		
};

#endif