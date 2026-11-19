#include <avr/io.h>
#include <stdint.h>
#include <stdio.h>

#define F_CPU 16000000UL
#include <util/delay.h>
#include <avr/interrupt.h>
#include "board.h"
#include "gpio_macros.h"


volatile uint32_t elapsed_ms = 0;

ISR(TIMER1_COMPA_vect) {
	++elapsed_ms;
}


static void timer1_init_1ms(void) {
	   TCCR1A = 0; TCCR1B = 0; TCNT1 = 0;
	   OCR1A = 249; // ~1 ms at 16 MHz / 64
	   TCCR1B |= (1u << WGM12); // CTC
	   TIFR1 |= (1u << OCF1A); // clear stale flag (W1C)
	   TIMSK1 |= (1u << OCIE1A); // enable compare-A interrupt
	   TCCR1B |= (1u << CS11) | (1u << CS10); // prescaler 64: starts the timer
}

volatile uint32_t now;
int main(void) {
	DDRB |= (1u << DDB5);
	timer1_init_1ms();
	sei();
	while (1) { 
		now = elapsed_ms;
	}
}