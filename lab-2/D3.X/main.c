/*
 * File:   main.c
 * Author: Amor
 *
 * Created on November 5, 2026, 3:36 PM
 */


#define F_CPU 16000000
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/atomic.h>

volatile uint8_t button_changed = 0;
volatile uint8_t previous_portb;


ISR(PCINT0_vect)
{
uint8_t current = PINB;
if ((current ^ previous_portb) & (1u << PB7)) button_changed = 1;
previous_portb = current;
}

int main(void)  {

    DDRB &= (uint8_t)~(1u << DDB7); PORTB |= (1u << PORTB7);
     // PB7 input, pull-up
    DDRB |= (1u << DDB5);
     // LED
    previous_portb = PINB;
    PCMSK0 |= (1u << PCINT7);
     // which pin
    PCIFR = (1u << PCIF0);
     // clear stale flag (W1C)
    PCICR |= (1u << PCIE0);
     // which group
    sei();

    while (1) {
        uint8_t ev;
        ATOMIC_BLOCK(ATOMIC_RESTORESTATE) { ev = button_changed; button_changed = 0; }
        if (ev) PORTB ^= (1u << PB5); // longer work stays in main()
    }
}