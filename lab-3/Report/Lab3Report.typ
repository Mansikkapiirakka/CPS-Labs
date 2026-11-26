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
      #table(columns: (1fr, 1fr, 1fr, 1fr, 1fr), stroke:0pt,
      [CPS Lab 3 Report],[Eaindray Oo], [Amor Moni], [Rodolfo Orefice], [Tommi Rajala],  
      [],[2521921], [2522938], [2525658], [2518054])
      ]
  )
#show link: underline

= CPS LAB 3 REPORT
#v(1em)

Board: ATmega328PB Xplained Mini  rev. 05\
Power supply:
  - TASK 0: Tenma 72-13310
  - TASKS 1-4 RIGOL DP932E.\
  #v(1em)

== TASK 0
#v(1em)
#table(columns: (1fr, 1fr, 1fr, 1fr, 1fr), stroke:0.2pt,
[R],           [$"V"_"R"$(osc)], [$"V"_"R"$(DMM)], [$"I"_"R"$(PSU)], [$I_R ("calc")$], 
[$10 Omega$],  [$368 "mV"$],     [$0.38 "V"$],     [$31 "mA"$],      [$36.8 "mA"$], 
[$1.06 Omega$], [$42 "mV"$],      [$0.04 "V"$],     [$35 "mA"$],      [$39.6 "mA"$], 
[$0.7$],       [too noisy],      [$0 "V"$],        [$37 "mA"$],      [$0 "mA"$], 
)
#figure(image("//assets/LAB3_TASK0.jpg", height:12cm), caption: "Current measurement setup with shunt resistor, oscilloscope and multimeter.")
#colbreak()
== TASK 1
#v(1em)

We used a simple program that toggles the LED on and off when pressing the onboard button.
#table(
  columns: 4,
  rows : 3, stroke:0.2pt,
  table.header(
    [Firmware], [Supply Voltage [V]], [Current [mA]], [Notes/Stability]
  ),
  [IDLE/BASELINE],[5.00 ],[39.8],[Seems stable, stared at 40.0 but lowered as it was powered on],
  [LED ON],[5.00],[42.3],[Also stable]
)
#figure(image("//assets/LAB3_TASK1.jpg", height:60%), caption: "Baseline current measurement with multimeter.")
#pagebreak()

== TASK 2
#v(1em)
  Running the same program, in idle.
  #table(
    columns: 5,
    rows: 2,
    stroke:0.2pt,
    table.header(
      [$R_"shunt" [Omega]$], [$V_"shunt" ["mV"]$],[Calculated $I ["mA"]$], [Meter $I ["mA"]$], [Difference [%]]
    ),
    [1],[40],[40],[39.9],[0.25],
  )
  #grid(
    columns: 2,
    column-gutter: 2pt,
    figure(image("/assets/LAB3_TASK2A.jpg"), caption: "Measured current."),
    figure(image("/assets/LAB3_TASK2V.png"), caption: "Measured voltage over the shunt.")
  )

  == TASK 3
#v(1em)
  #figure(image("../../assets/LAB3_TASK3_TRANSIENT.jpg"), caption: "One transient captured.")
#colbreak()
  == TASK 4
  #v(1em)
  All currents calculated with 1 $Omega$ shunt.
  #table(
    columns: 5,
    rows: 5,
    stroke:0.2pt,
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
    figure(image("/assets/LAB3_TASK4IDLE.jpg"), caption: "IDLE-state."),
    figure(image("/assets/LAB3_TASK4BUSY.jpg"), caption: "BUSY-state")
  )
  #v(1em)

  == TASK 5
#v(1em)
  The continuous mode toggles the onboard LED in a while loop and the duty cycled mode toggles the LED with a period of 100 ms and 10% duty cycle (10 ms).

#table(columns: 5, rows: 3, stroke:0.2pt, table.header(
  [Mode], [$I_"avg"$(mA)], [$I_"peak"$(mA)], [Period(ms)], [Activity / Wait Ratio]),
[Continuous], [42.2], [44.2], [$infinity$], [100%],
[PWM], [39.5], [43.4], [100], [10%])

The reduction in current consumption is 6.4%.
Even with a reduction in duty cycle, the board has a lot of overhead in current consumption. To reduce overhead, unnecessary peripherals should be
turned off.

  #grid(
    columns: 2,
    column-gutter: 2pt,
    figure(image("/assets/LAB3_TASK5_Continuous.jpg"), caption: "Continuous mode"),
    figure(image("/assets/LAB3_TASK5_DutyCycle.jpg"), caption: "Duty cycle mode")
  )

#colbreak()
  == TASK 6
  #v(1em)
  #table(columns: (1fr, 1fr, 1fr), rows: 3, stroke:0.2pt,
  [Firmware condition], [Iavg (mA)], [Supply Voltage (V)], 
  [Active / Reference], [$35.7$ ], [5 V], 
  [Sleep / low power], [$28.6$], [ 5 V],  
  )
 

  #figure(image(height:5cm,"/assets/LAB3_TASK6_reference.png"), caption: "reference condition")
  #figure(image(height: 6cm,"/assets/LAB3_TASK6_sleep.png"), caption:"sleep condition" )

The measurements highlights a difference between active and sleep mode. While in active mode the board consumes and average of 36.7 mA, in sleep mode the average current drops to 28.6 mA.
#v(1em)
== TASK 7
#v(1em)
    #table(columns: (1fr, 1.1fr, 1fr, 1fr, 1fr, 1fr), rows: 3, stroke:0.2pt,
  [Condition], [Supply Voltage (V)], [Current (mA)], [Power (mW)], [E(Wh) estimated], [Battery life (days) estimated],
  [Baseline], [5.0], [41], [205], [0.205],[2.03],
  [Continuous], [5.0], [42.5], [212.5], [0.2125],[1.96],
  [Duty Cycle], [5.0], [41], [205], [0.205],[2.03],
  [Sleep], [5.0], [28.6], [143],  [0.143],[2.91],
  )
/*  
Battery life (h) ≈ capacity (mAh) / average current (mA).
$ 2000/41=48.78\
  2000/42.5=47.06\
  2000/41=48.78\
  2000/28.6=69.93\
 $


Battery life (days) = battery life (hours) / 24

$
  
  48.78/24=2.03\
  47.06/24=1.96\
  48.78/24=2.03\
  69.93/24=2.91\
$
*/

Among oscilloscope and multimeter measurements, variations may differ. Among the reasons for this is that oscilloscope is sampling the signal at a much higher frequency than the multimeter, which is averaging the signal over a longer period of time. The oscilloscope is also more sensitive to noise and transients, which can affect the readings. Additionally, the multimeter may have a slower response time and may not capture rapid changes in current as accurately as the oscilloscope.
