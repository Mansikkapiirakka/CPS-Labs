#import "@preview/unify:0.8.1": *
#import "@preview/physica:0.9.8": *
#import "@preview/cetz:0.5.2": *

#set page(
    paper: "a4",
    margin: (x: 5%, y: 7%) ,
    number-align: bottom+right,
    numbering: "1 of 1",
    header: align(center+horizon)[
      #set text(11pt)
      Eaindray Oo, Amor Moni, Rodolfo Orefice, Tommi Rajala \ 
      student-number, 2522938, num3, 2518054
      ]
  )

= CPS LAB 2 REPORT 

==== D1

==== D2
  3. 
  #table( 
    rows: 2, 
    columns: 5,
    [Trigger mode], [Falling edge], [Rising edge], [Any logical change in logic level], [Low level],
   [\# of triggers per button press:], [1],[1],[2],[Continuous inputs]
  )
  4.
  Low level triggers the flag continuously because the button is active low, so when pressed down there is a low logic level continuously, triggering the interrupt.
  5. 
  A pull-up is needed for a stable input, because a floating input is influenced by noise and unknowable. 

 #line(length: 100%)
==== D3
  2.
  The ISR must be able to identify the source, because if multiple pins change on the same port, they would both trigger the interrupt, so ISR must know which pin to trigger for.
  3.
  PCINT may be triggered from multiple pins from different ports, while INT0 can only be triggered by PD2. PCINT has no trigger selection, only logic level change. INT0 has a selection of four trigger modes.
  4.
  The button won't do anything, since the PCMSK0 enables interrupting for the pins.

   #line(length: 100%)
==== D4
  1.
  The register values matched with the code.
  2.
  Prediction: The new period is 2 ms.
  Measurement agrees with the prediction.
  3.
  $f_"new" = (16 "MHz") / 256 = 62.5 "kHz"$\
  $"OCR1A" = 62.5 "kHz" * 1 "ms" - 1= 61.5$\
  The correct value for the OCR1A is a decimal number.
  This can't be represented in the OCR1A register.
  The correct value must be rounded, which causes error in the timing. The error is $plus.minus 8 mu"s"$ depending on how the value is rounded.
  4.
  The ticks were implemented into the interrupt service routine.
    ```C 
      ISR(TIMER1_COMPA_vect) {
	      if (++elapsed_ms >= 9) { 
		      elapsed_ms = 0; ten_ms_tick++; 
		      if ((ten_ms_tick % 10) == 0) {hundred_ms_tick++;}
	      }
      }
    ```
  5.
  The ISR must not contain \_delay\_(500), because that would block all other execution for half a second.

==== D5

1.
Prescaler = 64 :\
$f = (16 "MHz")/(64) = 250 "kHz"$\
$T_"overflow" = 256 / (250 "kHz") = 1024 mu"s"$

Prescaler = 1024:\
$f = (16 "MHz")/(1024) = 15.625 "kHz"$\
$T_"overflow" = 256/(15.625 "kHz") = 16.384 mu"s"$

2.
TOV0 is a flag that is set when Timer0 overflows.
TOIE0 is the enable bit for the Timer0 overflow interrupt service routine.

3.
Timer1 can achieve an exact interval of 1ms. Timer0 overflow can achieve an interval of 1.024 ms.

==== Method 1
Measured cycle count and time.
The ISR takes 14 cycles. There was some weird anomaly of 79 cycles. Likely caused when the second if branch is hit.

The actual counted time is roughly 900 ns shorter than it should be.
#image("/assets/image.png")

==== Method 2

With all branches included, the cycle count is 79. With no branching the cycle count is 14.

Which matches our observations.
#pagebreak()
=== Case 1

If sei() is never called, interrupts will be disabled globally. The figure below represents the status register.
Bit-7 (I) represents the global interrupt enable.

#image("/assets/image-1.png")

OCIE1A is enabled

#image("/assets/image-2.png")

TCNT1 starts at 0

#image("/assets/image-3.png")

OCF1A is never reset

#image("/assets/image-4.png")

=== Case 2

The compiler emmits a warning about a misspelled signal handler.
The built succeeds
#image("/assets/image-5.png")

When comparing the disassembled files of the misspelled version and the correct one, you can notice that the misspelled version is significantly shorter.
Instead of replacing the wrong vector jump with a '\_bad\_interrupt', the compiler seems to have optimized out the parts of the program that are never triggered and removed unused variables.

Here's the disassembled correct program:

#set text(size : 6pt)
!\#include \<avr/io.h>\
!\#include \<avr/io.h>\
!\#include \<stdint.h>\
!\#define F_CPU 16000000UL\
!\#include \<util/delay.h>\
!\#include \<avr/interrupt.h>\
!volatile uint16_t elapsed_ms = 0;\
!volatile uint8_t led_due = 0;\
!volatile uint16_t ten_ms_tick = 0;\
!volatile uint16_t hundred_ms_tick = 0;\
!ISR(TIMER1_COMPA_vect) {\
0x6E: PUSH R0\
0x6F: IN R0, 0x3F\
0x70: PUSH R0\
0x71: PUSH R1\
0x72: EOR R1, R1\
0x73: PUSH R18\
0x74: PUSH R19\
0x75: PUSH R20\
0x76: PUSH R21\
0x77: PUSH R22\
0x78: PUSH R23\
0x79: PUSH R24\
0x7A: PUSH R25\
0x7B: PUSH R26\
0x7C: PUSH R27\
!	if (++elapsed_ms >= 9) { \
0x7D: LDS R24, 0x105\
0x7F: LDS R25, 0x106\
0x81: ADIW R24, 0x01\
0x82: STS 0x106, R25\
0x84: STS 0x105, R24\
0x86: SBIW R24, 0x09\
0x87: BRCS 0xBA\
!		elapsed_ms = 0; ten_ms_tick++; \
0x88: STS 0x106, R1\
0x8A: STS 0x105, R1\
0x8C: LDS R24, 0x102\
0x8E: LDS R25, 0x103\
0x90: ADIW R24, 0x01\
0x91: STS 0x103, R25\
0x93: STS 0x102, R24\
!		if ((ten_ms_tick % 10) == 0) {hundred_ms_tick++;}\
0x95: LDS R20, 0x102\
0x97: LDS R21, 0x103\
0x99: MOVW R18, R20\
0x9A: LDI R26, 0xCD\
0x9B: LDI R27, 0xCC\
0x9C: CALL __umulhisi3\
0x9E: MOVW R18, R24\
0x9F: LSR R19\
0xA0: ROR R18\
0xA1: LSR R19\
0xA2: ROR R18\
0xA3: LSR R19\
0xA4: ROR R18\
0xA5: MOVW R24, R18\
0xA6: ADD R24, R24\
0xA7: ADC R25, R25\
0xA8: ADD R24, R24\
0xA9: ADC R25, R25\
0xAA: ADD R24, R18\
0xAB: ADC R25, R19
0xAC: ADD R24, R24\
0xAD: ADC R25, R25\
0xAE: CP R20, R24\
0xAF: CPC R21, R25\
0xB0: BRNE 0xBA\
0xB1: LDS R24, 0x100\
0xB3: LDS R25, 0x101\
0xB5: ADIW R24, 0x01\
0xB6: STS 0x101, R25\
0xB8: STS 0x100, R24\
!	}\
!}\
0xBA: POP R27\
0xBB: POP R26\
0xBC: POP R25\
0xBD: POP R24\
0xBE: POP R23\
0xBF: POP R22\
0xC0: POP R21\
0xC1: POP R20\
0xC2: POP R19\
0xC3: POP R18\
0xC4: POP R1\
0xC5: POP R0\
0xC6: OUT 0x3F, R0\
0xC7: POP R0\
0xC8: RETI\
0xC9: SBI 0x04, 5\
!static void timer1_init_1ms(void) {\
0xCA: STS 0x80, R1\
!	   TCCR1A = 0; TCCR1B = 0; TCNT1 = 0;\
0xCC: LDI R30, 0x81\
0xCF: STS 0x85, R1\
!	   OCR1A = 249; // ~1 ms at 16 MHz / 64\
0xD3: LDI R24, 0xF9\
!	   TCCR1B |= (1u << WGM12); // CTC\
0xD9: LD R24, Z\
0xDA: ORI R24, 0x08\
!	   TIFR1 |= (1u << OCF1A); // clear stale flag (W1C)\
0xDC: SBI 0x16, 1

#set text(size : 11pt)

Here's the disassembled program with the misspelled vector:

#set text(size : 5pt)

!int main(void) {\
0x6E: SBI 0x04, 5\
!	DDRB |= (1u << DDB5);\
!	timer1_init_1ms();\
0x6F: STS 0x80, R1\
!	sei();\
0x8A: SEI\
!	while (1) { \
0x8C: LDS R24, 0x100\
!		if (led_due) { led_due = 0; PORTB ^= (1u << PB5); } \
0x8B: LDI R25, 0x20\
0x8E: CP R24, R1\
0x8F: BREQ 0x8C\
0x90: STS 0x100, R1\
0x92: IN R24, 0x05\
0x93: EOR R24, R25\
0x94: OUT 0x05, R24\
0x95: RJMP 0x8C\

#set text(size : 11pt)

=== Case 3

Time between ISR entries is about 16 ms
#image("/assets/image-7.png")

$"tick" = "period" / ("OCR1A" + 1)$\

$"period" approx 16 "ms"$

$"OCR1A" = 249$

$"tick" = (16 "ms")/(249+1) = 64 mu s$

This corresponds to a frequency of 15625 Hz,
which is 16 MHz / 1024.
Therefore we can conclude that our prescaler is 1024.

A prescaler value of 101 corresponds to a prescaler value of 1024.
The clock select bits agree with our observations.
#image("/assets/image-8.png")

=== Case 4

Variable 'now' and and 'elapsed_ms' before interrupt and after low order byte read:

#image("/assets/image-9.png")

After interrupt and high order byte read:
#image("/assets/image-10.png")

==== H

+ Find the vector names for INT0, INT1, PCINT0, Timer1 compare A and Timer1 overflow. \
  
  No mention of vector names in the datasheet, but they are found in the header file:
     #table(columns: (1fr, 1fr, 1fr), align: center, stroke: 0.2pt, 
    [Interrupt source], [Vector name],[Interrupts definition],
    [INT0], [INT0_vect], [External Interrupt Request 0],
    [INT1], [INT1_vect], [External Interrupt Request 1],
    [PCINT0], [PCINT0_vect], [Pin Change Interrupt 0],
    [Timer1 compare A], [TIMER1_COMPA_vect], [Timer1 Compare A Match],
    [Timer1 overflow], [TIMER1_OVF_vect], [Timer1 Overflow])
    
+ Write the four EICRA trigger combinations for INT0.\
   
  + 00 - The low level of INT0 generates an interrupt request.
  + 01 - Any logical change on INT0 generates an interrupt request.
  + 10 - The falling edge of INT0 generates an interrupt request.
  + 11 - The rising edge of INT0 generates an interrupt request.

+ Explain why clearing a flag differs from enabling a source (EIMSK versus EIFR).\

  Enabling a source allows the interrupt to be triggered, while clearing a flag is done after the interrupt has been triggered to reset the flag for future interrupts.
  
+ Identify the bit that selects CTC mode, and the bit pattern for divide-by-64.\
  
  CTC mode is selected by setting WGM12 to 1 and WGM13, WGM11, WGM10 to 0. \
  The bit pattern for divide-by-64 is $"CS12"=0$, $"CS11"=1$, $"CS10"=1$.

+ Find the Timer1 compare-A enable bit and flag bit.\

  The Timer1 compare-A enable bit is OCIE1A in the TIMSK1 register, and the flag bit is OCF1A in the TIFR1 register.

+ Identify the input-capture edge-select bit.\
  
  The input-capture edge-select bit is ICES1 in the TCCR1B register.

+ Find the interrupt response time and RETI time in the datasheet and check Figure 13 against them.\

  The datasheet specifies a time of 4 clock cycles for both the interrupt response and the RETI time. Figure 13 shows a larger latency (about 20–30 cycles) where completion of the current instruction, interrupt synchronization, vector jump overhead, and the compiler-generated ISR prologue before the first instruction of the ISR body are also included. RETI corresponds to the final 4-cycle block shown in the figure.

+ Explain why Timer3/Timer4 examples must not be copied into an ATmega328P project.\
  A:


==== I - The MiniProject
  #figure(image("../../assets/I-State-Diagram.png"), caption: "State Diagram of the MiniProject.")
  The full implementation can be found on the GitHub, in section I. Some of the parts of the implementation are below, along with explanations. The implementation starts with defining an enum for the states:
  #set text(8pt)
  ```c
    typedef enum State {
      IDLE = (volatile uint8_t) 1,
      WAIT = (volatile uint8_t) 2,
      MEASURE = (volatile uint8_t) 3,        
      RESULT = (volatile uint8_t) 4,
      ABORTED = (volatile uint8_t) 5 
    } State;
  ```
  #set text(11pt)
  Then after declaring all of the functions and variables we get to  ```c main()```:
  #set text(8pt)
  ```c
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
          
          if (abort){
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
                          measurement_result_ms = system_time_ms - measurement_start_ms + random_delay_ms ;
                          CLR_BIT(LED_PORT, LED);
                          gameState = RESULT;
                          if (results[results_len-1] == 0){
                              for(uint8_t i = 0; i < results_len; i++){
                                  if (results[i] == 0) {
                                      results[i] = measurement_result_ms;
                                      break;
                                  }
                              }
                          } else {
                              for(uint8_t i = 0; i< results_len-1; i++) {
                                  results[i] = results[i+1];
                              }
                              results[results_len-1] = measurement_result_ms;
                          }
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
                  CLR_BIT(LED_PORT, LED);
                  }
                  break;
              }
          
      }
}
  ```
  #set text(11pt)
  In main generate random numbers using C standard library function ```c rand()```, which is seeded with ```c srand()```. Then we initialize the timer and IO, and enable interrupts. Then the main loop starts, which handles the game states and reaction time results. All shared volatile variables are protected with atomic blocks.
  
  I.5.1 
    
  The delay selector is built using C standard library functions ```c rand()``` and ```c srand()```.\ 
  The modulus ```c (upper_limit-lower_limit+1)=(5000-2000+1)=2999``` of the randomly generated number is taken; \
  ```c rand() % 2999```. Finally the lower limit, 2000, is added to get our final delay time.

  I.5.2

  We prevent index overflow with the following code, which writes to the array until the array is full. Then it simply shifts the contents to the left, overwriting the first and oldest result, before writing the new result in the last slot.
  ```c
    if (results[results_len-1] == 0){
       for(uint8_t i = 0; i < results_len; i++){
          if (results[i] == 0) {
            results[i] = measurement_result_ms;
            break;
          }
        }
    } else {
      for(uint8_t i = 0; i< results_len-1; i++) {
        results[i] = results[i+1];
      }
      results[results_len-1] = measurement_result_ms;
    }  
  ```
  I.5.3

  Case 6 would not occur in our implementation, since the MEASURE case is not entered until the measuring starts, so pressing INT0 during the wait does nothing.

  I.5.4

  TIMER ISR: 41 cycles, $qty(2.5625, "us")$, % of 1 ms: $approx$ 0.26%

  INT1 ISR: 64 cycles, $qty(4, "us")$, % of 1 ms: 0.4 %

  INT0 ISR: 64 cycles, $qty(4, "us")$

==== J

Using interrupts we can put the MCU in sleep and have it wake up on interrupt. This way we can save huge amounts of energy.
We learned how different MCU functionalities are configured using registers. 
We learned how to use debugging tools to diagnose software issues, such as missing atomic blocks and interrupts that are not activating.
It was interesting to see how a race condition causes data corruption. The exercise with the  TIMER1_COMPA interrupt and the 32-bit value was a great example of this.

*Bitwise Programming*

Here's an example bitwise operation:

TCCR1B |= (1 << WGM12)

If the operation was not bitwise, all other bits would be set to 0. But we only want to set WGM12, so we must use a bitwise operation.

*Timer Calculations*


At 16 MHz with a prescaler value 8, the timer1 frequency is 2 MHz

$"tick" = (8)/(16 "MHz") = 500 "ns"$
#pagebreak()
*Design and Debugging*

Interrupts are disabled for 5 ms while a 1 ms compare flag is generated repeatedly. Will the CPU run
five ISRs afterwards? Explain

There is only a single bit for storing the interrupt flag.
The CPU doesn't store all 5 events, so only a single ISR
will be run.

