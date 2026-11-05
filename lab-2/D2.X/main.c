/*
 * File:   main.c
 * Author: Amor
 *
 * Created on November 5, 2026, 12:21 PM
 */

#define F_CPU 16000000
#include <avr/io.h>
#include <avr/interrupt.h>

volatile uint8_t EventFlag = 0; 

int main(void) {
    DDRB |= (1u << PB5);
    DDRD &= ~(1u << PD2);       //set extButton input; DataDirectionRegisterD
    PORTD |= (1u << PD2);       //pull-up resistor
    DDRD &= ~(1u << PD3);       //set extButton input; DataDirectionRegisterD
    PORTD |= (1u << PD3);       //pull-up resistor
    
    
    EICRA &= ~(1u << ISC10);    //ExternalInterruptControlRegisterA; set bit 0 InterruptSenseControl 0 
    EICRA |= (1u << ISC11);     // set bit 1 to 1 --> by setting to 10 activate falling edge
    
    EIFR &= ~(1u << INTF1);     //ExternalInterruptFlagRegister; clear flag1
    EIMSK |= (1u << INT1);      //ExternalInterruptMaSKregister; enable ExternalInterrupt1
    sei();                      //Enable Interrupt Globally 
    
    

    while (1) {

        
        if (EventFlag) {
            PORTB ^= (1u << PB5);
            EventFlag = 0;
        } 

        
    }
}

ISR(INT1_vect) {            //When Interrupt1 execute...
    PORTB ^= (1u << PB5); 
      
}