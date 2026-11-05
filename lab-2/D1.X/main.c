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
    DDRD &= ~(1u << PD2);       //set extButton input; DataDirectionRegisterD
    PORTD |= (1u << PD2);       //pull-up resistor
    
    
    EICRA &= ~(1u << ISC00);    //ExternalInterruptControlRegisterA; set bit 0 InterruptSenseControl 0 
    EICRA |= (1u << ISC01);     // set bit 1 to 1 --> by setting to 10 activate falling edge
    
    EIFR &= ~(1u << INTF0);     //ExternalInterruptFlagRegister; clear flag0
    EIMSK |= (1u << INT0);      //ExternalInterruptMaSKregister; enable ExternalInterrupt0
    sei();                      //Enable Interrupt Globally 
    
    while (1) {
        
    }
}

ISR(INT0_vect) {            //When Interrupt0 execute...
    PORTB ^= (1u << PB5);   
}