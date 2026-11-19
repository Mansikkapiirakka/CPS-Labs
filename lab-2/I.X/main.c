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
#include "board.h"

typedef enum State {
    IDLE = (uint8_t) 1,
    WAIT = (uint8_t) 2,
    MEASURE = (uint8_t) 3,        
    RESULT = (uint8_t) 4,
    ABO = (uint8_t) 5 // ABORT is apparently taken
} State;

static void io_init();
static void timer_init();
ISR(INT0_vect);
ISR(INT1_vect);
ISR(TIMER1_COMPA_vect);

volatile uint32_t system_time_ms;
volatile uint8_t State = IDLE, abort = 0, start = 0; 

static uint8_t int0_triggered = 0, int1_triggered =0;
static uint32_t int0_last_time = 0, int1_last_time = 0;


int main() {
    
    io_init();
    timer_init();
    
    while (1) {
        
        if (abort) {
            CLR_BIT(LED_PORT, LED);
        }
        
    }
    
    

    return (EXIT_SUCCESS);
}


static void io_init() {
    // Initialize button and abort button with pull-ups
    CLR_BIT(BUTTON_DDR, BUTTON);
    SET_BIT(BUTTON_PORT, BUTTON);
    CLR_BIT(BUTTON_DDR, ABORT);
    SET_BIT(BUTTON_PORT, ABORT);
    
    // Falling edge for pulled-up buttons
    CLR_BIT(EICRA, ISC10);
    CLR_BIT(EICRA, ISC11);
    
    // Clear stale flags
    CLR_BIT(EIFR, INTF0);
    CLR_BIT(EIFR, INTF1);
    
    SET_BIT(EIMSK, INT1);
    SET_BIT(EIMSK, INT0);
    
    SET_BIT(LED_DDR, LED);
    CLR_BIT(LED_PORT, LED);
    
} /* IO and interrupt init */

static void timer_init(){
 
   TCCR1A = 0; TCCR1B = 0; TCNT1 = 0;
   OCR1A = 249; // ~1 ms at 16 MHz / 64
   TCCR1B |= (1u << WGM12); // CTC
   TIFR1 &= ~(1u << OCF1A); // clear stale flag (W1C)
   TIMSK1 |= (1u << OCIE1A); // enable compare-A interrupt
   TCCR1B |= (1u << CS11) | (1u << CS10); // prescaler 64: starts the timer
} /* Initialize timer1 CTC every 1 ms */

ISR(INT1_vect){
    uint32_t now = system_time_ms;
    if (!int1_triggered || (now - int1_last_time) >= 30u ) {
        int1_triggered = 1;
        int1_last_time = now;
        abort = 1;
    }
}

ISR(TIMER1_COMPA_vect){
    system_time_ms++;
}