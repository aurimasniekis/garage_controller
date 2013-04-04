#ifndef _FLOURESCENT_LAMP_H_
#define _FLOURESCENT_LAMP_H_
#include "../hardware/gpio.h"

class FlourescentLamp
{
	public:
		FlourescentLamp(GPIOPin pin);
		void turnOn();
		void turnOff();
	private:
		GPIOPin *gpio_pin;
};

#endif