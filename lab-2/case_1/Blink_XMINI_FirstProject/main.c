#include <avr/io.h>
#include <stdint.h>

#define F_CPU 16000000UL
#include <util/delay.h>
#include <avr/interrupt.h>

volatile uint16_t elapsed_ms = 0;
volatile uint8_t led_due = 0;
volatile uint16_t ten_ms_tick = 0;
volatile uint16_t hundred_ms_tick = 0;

ISR(TIMER1_COMPA_vect) {
	if (++elapsed_ms >= 9) { 
		elapsed_ms = 0; ten_ms_tick++; 
		if ((ten_ms_tick % 10) == 0) {hundred_ms_tick++;}
	}
}

static void timer1_init_1ms(void) {
	   TCCR1A = 0; TCCR1B = 0; TCNT1 = 0;
	   OCR1A = 249; // ~1 ms at 16 MHz / 64
	   TCCR1B |= (1u << WGM12); // CTC
	   TIFR1 |= (1u << OCF1A); // clear stale flag (W1C)
	   TIMSK1 |= (1u << OCIE1A); // enable compare-A interrupt
	   TCCR1B |= (1u << CS11) | (1u << CS10); // prescaler 64: starts the timer
}

int main(void) {
	DDRB |= (1u << DDB5);
	timer1_init_1ms();
	sei();
	while (1) { 
		if (led_due) { led_due = 0; PORTB ^= (1u << PB5); } 
	}
}