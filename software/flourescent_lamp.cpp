#include "flourescent_lamp.h"

FlourescentLamp::FlourescentLamp(GPIOPin pin) {
	gpio_pin = &pin;
}

void FlourescentLamp::turnOn() {
	gpio_pin->write(0x4);
}

void FlourescentLamp::turnOff() {
	gpio_pin->write(0x0);
}