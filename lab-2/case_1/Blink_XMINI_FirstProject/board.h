// board.h
#ifndef BOARD_H
#define BOARD_H

#include <avr/io.h>

//#define F_CPU_HZ		16000000UL
#define LED_DDR			DDRB
#define EXT_LED_DDR		DDRD
#define LED_PORT		PORTB
#define EXT_LED_PORT	PORTD
#define LED_PIN			PB5
#define EXT_LED_PIN		PD2

#endif