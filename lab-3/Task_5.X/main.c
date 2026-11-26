/*
 * File:   main.c
 * Author: Amor
 *
 * Created on November 25, 2026, 3:20 PM
 */

#define F_CPU 16000000UL
#include <avr/io.h>
#include <stdint.h>
#include <avr/interrupt.h>

#define LED_PIN PB5

//#define DUTY
#define CONTINUOUS

#ifdef DUTY
#ifdef CONTINUOUS
#error "Duty cycled mode and continuous mode can't be used simultaneously"
#endif
#endif

void setup(void);

volatile uint8_t elapsed_ms = 0;

int main(void) {
    setup();
#ifdef DUTY
    sei();
#endif
    while (1) {
#ifdef CONTINUOUS
        PORTB ^= (1u << PB5);
#endif
    }
}

#ifdef DUTY
ISR(TIMER1_COMPA_vect) {
    elapsed_ms++;
    if (elapsed_ms >= 10) PORTB &= ~(1u << LED_PIN);
    if (elapsed_ms >= 100) {
        PORTB |= (1u << LED_PIN);
        elapsed_ms = 0;
    }
}
#endif


void setup(void) {
    DDRB |= (1 << LED_PIN);
#ifdef DUTY    
    TCCR1A = 0; TCCR1B = 0; TCNT1 = 0;

    //CTC mode
    TCCR1B |= (1u << WGM12);
    
    //Prescaler : 64
    TCCR1B |= (1u << CS11) | (1u << CS10);
    
    //TOP 1ms
    OCR1A = 249L;
    
    TIMSK1 |= (1u << OCIE1A) /*| (1u << OCIE1B)*/;
	TIFR1 |= (1u << OCF1A);
#endif
}
