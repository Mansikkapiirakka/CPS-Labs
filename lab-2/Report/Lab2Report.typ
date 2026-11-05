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
  5.
  The ISR must not contain \_delay\_(500), because that would block all other execution for half a second.