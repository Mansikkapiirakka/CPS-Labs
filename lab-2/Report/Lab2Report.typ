#import "@preview/unify:0.8.1": *
#import "@preview/physica:0.9.8": *
#import "@preview/cetz:0.5.2": *

#set page(
    paper: "a4",
    margin: (x: 5%, y: 7%) ,
    number-align: bottom+right,
    numbering: "1 of 1",
    header: align(right+horizon)[
      #set text(10pt)
      Student \ student-number
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