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
      2521921, #h(0.7cm) 2522938, #h(0.9cm) 2525658, #h(1cm) 2518054
      ]
  )
#show link: underline

= CPS LAB 3 REPORT

== TASK 0

== TASK 1

We used a simple program that toggles the LED on and off when pressing the onboard button.
#table(
  columns: 4,
  rows : 3,
  table.header(
    [Firmware], [Supply Voltage [V]], [Current [mA]], [Notes/Stability]
  ),
  [IDLE/BASELINE],[5.00 ],[39.8],[Seems stable, stared at 40.0 but lowered as it was powered on],
  [LED ON],[5.00],[42.3],[Also stable]
)
#figure(image("//assets/LAB3_TASK1.jpg", height:70%), caption: "Baseline current measurement with multimeter.")
#pagebreak()

== TASK 2
  Running the same program, in idle.
  #table(
    columns: 5,
    rows: 2,
    table.header(
      [$R_"shunt" [Omega]$], [$V_"shunt" ["mV"]$],[Calculated $I ["mA"]$], [Meter $I ["mA"]$], [Difference [%]]
    ),
    [1],[40],[40],[39.9],[0.25],
  )
  #grid(
    columns: 2,
    column-gutter: 2pt,
    figure(image("../../assets/LAB3_TASK2A.jpg"), caption: "Measured current."),
    figure(image("../../assets/LAB3_TASK2V.png"), caption: "Measured voltage over the shunt.")
  )

== TASK 3