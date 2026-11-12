/*
 * File:   main.c
 * Author: Amor
 *
 * Created on November 12, 2026, 2:38 PM
 */

#define F_CPU 16000000UL
#include <avr/io.h>
#include <avr/interrupt.h>
#include <stdint.h>

volatile uint16_t overflow_count = 0;

ISR(TIMER0_OVF_vect) { overflow_count++; }

int main(void) {
    TCCR0A = 0; TCCR0B = 0; TCNT0 = 0;
    TIFR0 = (1u << TOV0); // clear flag (W1C)
    TIMSK0 |= (1u << TOIE0); // enable overflow interrupt
    TCCR0B |= (1u << CS01) | (1u << CS00); // prescaler 64: 1.024 ms
    sei();
    while (1) { }
}
