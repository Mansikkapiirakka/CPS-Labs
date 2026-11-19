/* 
 * File:   main.c
 * Author: tommi
 *
 * Created on November 19, 2026, 11:31 AM
 */

#define F_CPU = 16000000U 
#include <avr/io.h>
#include <stdio.h>
#include <stdlib.h>
#include <util/atomic.h>
#include <stdint.h>
#include "gpio_macros.h"

void io_init();


int main(int argc, char** argv) {

    return (EXIT_SUCCESS);
}


void io_init() {
    CLR_BIT(BUTTON_DDR, BUTTON);
    SET_BIT(BUTTON_PORT, BUTTON);
    CLR_BIT(BUTTON_DDR, ABORT);
    SET_BIT(BUTTON_PORT, ABORT);
    
    SET_BIT(LED_DDR, LED);
    
} /*  */