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

Board: ATmega328PB Xplained Mini  rev. 05\
Power supply: TASK 0: Tenma 72-13310, TASKS 1-4 RIGOL DP932E.\

== TASK 0

#table(columns: (1fr, 1fr, 1fr, 1fr, 1fr), stroke:0.2pt,
[R],           [$"V"_"R"$(osc)], [$"V"_"R"$(DMM)], [$"I"_"R"$(PSU)], [$I_R ("calc")$], 
[$10 Omega$],  [$368 "mV"$],     [$0.38 "V"$],     [$31 "mA"$],      [$36.8 "mA"$], 
[$1.06 Omega$], [$42 "mV"$],      [$0.04 "V"$],     [$35 "mA"$],      [$39.6 "mA"$], 
[$0.7$],       [too noisy],      [$0 "V"$],        [$37 "mA"$],      [$0 "mA"$], 
)

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
#figure(image("//assets/LAB3_TASK1.jpg", height:60%), caption: "Baseline current measurement with multimeter.")
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

  #figure(image("../../assets/LAB3_TASK3_TRANSIENT.jpg"), caption: "One transient captured.")

  == TASK 4
  All currents calculated with 1 $Omega$ shunt.
  #table(
    columns: 5,
    rows: 5,
    table.header(
      [State], [$I_"avg" ["mA"]$], [$I_"peak" ["mA"]$], [$V_"shunt"$ Baseline/peak], [Observations]
    ),
    [IDLE],[38.8],[42.1],[38.8/42.1],[],
    [GPIO],[38.9],[42.6],[38.9/42.6],[Rises to 41.7/45.2 when LED on],
    [BUSY],[40.0],[45.0],[40.0/45.0],[High avg and peak],
    [PERIODIC],[39.2],[43.9],[39.2/43.9],[Lower avg but peaks still high],
  )
  #grid(
    columns: 2,
    column-gutter: 2pt,
    figure(image("../../assets/LAB3_TASK4IDLE.jpg"), caption: "IDLE-state."),
    figure(image("../../assets/LAB3_TASK4BUSY.jpg"), caption: "BUSY-state")
  )