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

==== D3
  

==== D4