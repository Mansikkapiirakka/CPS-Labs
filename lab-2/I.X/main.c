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
    IDLE = (volatile uint8_t) 1,
    WAIT = (volatile uint8_t) 2,
    MEASURE = (volatile uint8_t) 3,        
    RESULT = (volatile uint8_t) 4,
    ABORTED = (volatile uint8_t) 5 
} State;

static void io_init();
static void timer_init();
ISR(INT0_vect);
ISR(INT1_vect);
ISR(TIMER1_COMPA_vect);

volatile uint32_t system_time_ms = 0, measurement_start_ms = 0, measurement_result_ms = 0;
volatile uint16_t random_delay_ms = 0;
volatile uint8_t  abort_flag = 0, start_flag = 0; 
State gameState = IDLE;

static uint8_t int0_triggered = 0, int1_triggered =0;
static uint32_t int0_last_time = 0, int1_last_time = 0;


int main() {
    
    srand(42u); // seed rand()
    io_init();
    timer_init();
    sei();
    
    while (1) {
        uint8_t start, abort;
        
        ATOMIC_BLOCK(ATOMIC_RESTORESTATE) {
            start = start_flag;
            abort = abort_flag;
            start_flag = 0;
            abort_flag = 0;
        }
        
        if (abort_flag){
            CLR_BIT(LED_PORT, LED);
            gameState = ABORTED;
        }
        switch (gameState) {
            case IDLE:
                if (start){
                    uint16_t random_delay = (rand() % (5000 - 2000 + 1)+ 2000);
                    ATOMIC_BLOCK(ATOMIC_RESTORESTATE){
                        gameState = WAIT;
                        random_delay_ms = random_delay;
                    }
                }   
                break;
            case WAIT:
                break;
            case MEASURE:
                if (start){
                    ATOMIC_BLOCK(ATOMIC_RESTORESTATE){
                        measurement_result_ms = system_time_ms - measurement_start_ms;
                        CLR_BIT(LED_PORT, LED);
                        gameState = RESULT;
                    }
                }
                break;
            case RESULT:
                if (start){
                    ATOMIC_BLOCK(ATOMIC_RESTORESTATE){
                        gameState = IDLE;
                    }
                }
                break;
            case ABORTED:
                ATOMIC_BLOCK(ATOMIC_RESTORESTATE){
                abort_flag = 0;
                gameState = IDLE;
                }
                break;
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

ISR(INT0_vect){
    uint32_t now = system_time_ms;
    if (!int0_triggered || (now-int0_last_time) >= 30u) {
        int0_triggered = 1;
        int0_last_time = now;
        start_flag = 1;
    }
}

ISR(INT1_vect){
    uint32_t now = system_time_ms;
    if (!int1_triggered || (now - int1_last_time) >= 30u ) {
        int1_triggered = 1;
        int1_last_time = now;
        abort_flag = 1;
    }
}

ISR(TIMER1_COMPA_vect){
    system_time_ms++;
    if(gameState == WAIT) {
        if(random_delay_ms > 0) random_delay_ms--;
        if(random_delay_ms == 0){
            measurement_start_ms = system_time_ms;
            gameState = MEASURE;
            SET_BIT(LED_PORT, LED);
        }
        
    }
}