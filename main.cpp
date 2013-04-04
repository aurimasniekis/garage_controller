#include <inc/LM4F120H5QR.h>
#include <inc/hw_ints.h>
#include <inc/hw_gpio.h>
#include <inc/hw_memmap.h>
#include <inc/hw_sysctl.h>
#include <inc/hw_types.h>
#include <driverlib/gpio.h>
#include <driverlib/sysctl.h>
#include <driverlib/interrupt.h>
#include <driverlib/timer.h>
#include <driverlib/uart.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hardware/gpio.h"
#include "software/flourescent_lamp.h"

GPIOPin lamp_1(GPIO_PORTF_BASE, GPIO_PIN_2, GPIO_DIR_MODE_OUT);
FlourescentLamp lamp(lamp_1);

int main(void) {
    
	lamp.turnOn();
	
    while(1) {
        
    }
    
    return 0;
}