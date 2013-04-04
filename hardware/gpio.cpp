#include <inc/hw_gpio.h>
#include <inc/hw_memmap.h>
#include <inc/hw_sysctl.h>
#include <inc/hw_types.h>
#include <driverlib/gpio.h>
#include <driverlib/rom.h>
#include <driverlib/sysctl.h>
#include <driverlib/pin_map.h>
#include <driverlib/can.h>
#include "gpio.h"

GPIOPin::GPIOPin(unsigned long Port, unsigned char Pin) {
   ulPort = Port;
   ucPin = Pin;
   GPIOPinTypeGPIOOutputOD(ulPort,ucPin);
}

GPIOPin::GPIOPin(unsigned long Port, unsigned char Pin, unsigned long PinIO) {
	ulPort = Port;
	ucPin = Pin;
	switch(PinIO) {
		case GPIO_DIR_MODE_IN:
			GPIOPinTypeGPIOInput(ulPort,ucPin);
			break;

		case GPIO_DIR_MODE_OUT:
			GPIOPinTypeGPIOOutput(ulPort,ucPin);
			break;
	}
}

GPIOPin::GPIOPin(unsigned long Port, unsigned char Pin, unsigned long PinIO, unsigned char Val) {
	ulPort = Port;
	ucPin = Pin;
	switch(PinIO) {
		case GPIO_DIR_MODE_IN:
			GPIOPinTypeGPIOInput(ulPort,ucPin);
			break;

		case GPIO_DIR_MODE_OUT:
			GPIOPinTypeGPIOOutput(ulPort,ucPin);
			break;
	}
	GPIOPinWrite(ulPort,ucPin,ucVal);
}

void GPIOPin::write(unsigned char Val) {
	GPIOPinWrite(ulPort,ucPin,Val);
}
long GPIOPin::read() {
	GPIOPinRead(ulPort, ucPin);
}
void GPIOPin::setDirMode(unsigned long PinIO) {
	GPIODirModeSet(ulPort, ucPin, PinIO);
}
unsigned long GPIOPin::dirMode() {
	GPIODirModeGet(ulPort, ucPin);
}
void GPIOPin::setConfig(unsigned long Strengh, unsigned long PinType) {
	GPIOPadConfigSet(ulPort, ucPin, Strengh, PinType);
}
void GPIOPin::config(unsigned long *Strengh, unsigned long *PinType) {
	GPIOPadConfigGet(ulPort, ucPin, Strengh, PinType);
}
