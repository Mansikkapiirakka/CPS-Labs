/*
 * File:   main.c
 * Author: Amor
 *
 * Created on November 5, 2026, 12:21 PM
 */

#define F_CPU 16000000
#include <avr/io.h>
#include <avr/interrupt.h>

int main(void) {
    DDRB |= (1u << PB5);
    DDRD &= ~(1u << PD2);
    PORTD |= (1u << PD2);
    
    EICRA &= ~(1u << ISC00);
    EICRA |= (1u << ISC01);
    
    EIFR &= ~(1u << INTF0);
    EIMSK |= (1u << INT0);
    sei();
    
    while (1) {
        
    }
}

ISR(INT0_vect) {
    PORTB ^= (1u << PB5);
}