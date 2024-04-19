*** 110062118_HW3_DFF ***

*.lib "/users/course/2023F/cs210401110000/u110062118/spice/pre_sim/cic018.l" TT

**Environment setting **
.temp 30
.option post
***********************************
.param w_p=2.5u
.param w_n=1u
*.param    CLK_Period = 20n
*.param    CLK_Period_2 = 'CLK_Period/2'
*.param    r_time = 1p
*.param    f_time = 1p

***I/O signal***
*input: M3 M2 M1 M0 Store Power Clk VDD VSS*
*output: State1 State0 S3 S2 S1 S0 Mo3 Mo2 Mo1 Mo0 Init3 Init2 Init1 Init0*
*** coinbank ***
.subckt Coin_bank State1 State0 S3 S2 S1 S0 Mo3 Mo2 Mo1 Mo0 Init3 Init2 Init1 Init0 M3 M2 M1 M0 Store Power Clk VDD VSS


Xtotal_DFF  next_s1 next_s0 ADD3 ADD2 ADD1 ADD0 Init3 Init2 Init1 Init0 Clk VDD VSS total_DFF
Xmoneyin_DFF M3 M2 M1 M0 MONEYIN3 MONEYIN2 MONEYIN1 MONEYIN0 Clk VDD VSS moneyin_DFF


XState_ctrl Power Store Clk S1 S2 State1 State0 s1_bar s0_bar next_s0 next_s1 VDD VSS State_ctrl

Xonehot_encoder_2to4 State1 State0 s1_bar s0_bar S3 S2 S1 S0 VDD VSS onehot_encoder_2to4
XDisplay_ctrl State1 State0 MONEYIN3 MONEYIN2 MONEYIN1 MONEYIN0 Init3 Init2 Init1 Init0 Mo3 Mo2 Mo1 Mo0 VDD VSS Display_ctrl

XRippleAdder_4bit MONEYIN3 MONEYIN2 MONEYIN1 MONEYIN0 Init3 Init2 Init1 Init0 VSS ADD3 ADD2 ADD1 ADD0 Cout VDD VSS RippleAdder_4bit


.ends Coin_bank


***  one-hot encoder ***
.subckt onehot_encoder_2to4 s1 s0 s1_bar s0_bar OUT3 OUT2 OUT1 OUT0 VDD GND

*Xbuf3 OUT3_tmp OUT3 VDD GND buffer
*Xbuf0 OUT0_tmp OUT0 VDD GND buffer 
Xand1 s1 s0 OUT3 VDD GND AND2
Xand2 s1 s0_bar OUT2 VDD GND AND2
Xand3 s1_bar s0 OUT1 VDD GND AND2

*Xinv s1 not_s1 VDD GND INV
*Xinv2 s0 not_s0 VDD GND INV


Xand4 s1_bar s0_bar OUT0 VDD GND AND2
.ends

***  buffer ***
.subckt buffer in OUT VDD GND

Mp1 tmp in VDD VDD p_18 w=5u l=0.18u
Mn1 tmp in GND GND n_18 w=2u l=0.18u

Mp2 OUT tmp VDD VDD p_18 w=10u l=0.18u
Mn2 OUT tmp GND GND n_18 w=4u l=0.18u

.ends

*** Inverter ***
.subckt INV in out vdd vss
Mp1 out in vdd vdd p_18 w=w_p l=0.18u 
Mn1 out in vss vss n_18 w=w_n l=0.18u 
.ends

**NOR**
.subckt NOR2  a b NOR vd gd
Mp1 1_to_2      a   vd         vd p_18 w=2.5u      l=0.18u
Mp2 NOR         b   1_to_2      vd p_18 w=2.5u      l=0.18u
Mn1 NOR         a   gd         gd n_18 w=1u   l=0.18u
Mn2 NOR         b   gd         gd n_18 w=1u   l=0.18u
.ends

**OR**
.subckt OR2 a b out VDD GND
XNOR2  a b out_bar VDD GND NOR2
Xinv out_bar out VDD GND INV
.ends

*** NAND2 ***
.subckt NAND2 x y NAND vdd vss
Mp1 NAND        x   vdd           vdd p_18 w=w_p l=0.18u 
Mp2 NAND        y   vdd           vdd p_18 w=w_p l=0.18u 
Mn1 mn1_to_mn2  x   vss           vss n_18 w=w_n   l=0.18u 
Mn2 NAND        y   mn1_to_mn2    vss n_18 w=w_n   l=0.18u 
.ends

*** AND2 ***
.subckt AND2 x y AND VDD GND
X1 x y xnandy VDD GND NAND2
Xinv xnandy AND VDD GND INV
.ends

*** NAND3 ***
.subckt NAND3 x y z NAND vdd vss
* PMOS transistors
Mp1 NAND x vdd vdd p_18 w=w_p l=0.18u
Mp2 NAND y vdd vdd p_18 w=w_p l=0.18u
Mp3 NAND z vdd vdd p_18 w=w_p l=0.18u

* NMOS transistors
Mn1 NAND x net1 vss n_18 w=w_n l=0.18u
Mn2 net1 y net2 vss n_18 w=w_n l=0.18u
Mn3 net2 z vss  vss n_18 w=w_n l=0.18u
.ends

*** DFF ***
.subckt DFF CLK D Q Q_ VDD GND 

X1 orange green purple VDD GND NAND2
X2 CLK purple green VDD GND NAND2
X3 green CLK  orange red VDD GND NAND3
X4 red D orange VDD GND NAND2


X5 green Q_ Q VDD GND NAND2
X6 Q red Q_ VDD GND NAND2

.ends

*** Transmission Gate ***
.subckt TG in s s_bar out vdd vss
Mp1 out s_bar in vdd p_18 w=w_p l=0.18u
Mn1 out s     in vss n_18 w=w_n l=0.18u
.ends

*** 2_to_1 MUX ***
.subckt TG_MUX A B S OUT VDD GND
Xinv S S_bar VDD GND INV
XTG1 A S_bar S      OUT VDD GND TG
XTG2 B S     S_bar  OUT VDD GND TG
.ends

*** 2x1 Multiplexer ***
.subckt MUX A B S OUT VDD GND 
XINV S S_bar VDD GND INV 
XNAND1 A S_bar NAND_AS VDD GND NAND2
XNAND2 B S NAND_BS VDD GND NAND2
XNAND3 NAND_AS NAND_BS OUT VDD GND NAND2
.ends

***XOR ***
.subckt XOR2 a b OUT VDD GND
Xinva a a_bar VDD GND INV
Xinvb b b_bar VDD GND INV
XTG1 a  b_bar b OUT VDD GND TG
XTG2 a_bar b  b_bar  OUT VDD GND TG
.ends

***  HalfAdder ***
.subckt HalfAdder A B S C VDD GND
XXOR a b S VDD GND XOR2
XAND2 a b C VDD GND AND2
.ends

***  FullAdder ***
.subckt FullAdder A B Cin S Cout VDD GND
XHalfAdder1 A B Stmp Ctmp VDD GND HalfAdder
XiHalfAdder2 Stmp Cin S Ctmp2 VDD GND HalfAdder
XOR Ctmp Ctmp2 Cout VDD GND OR2 
.ends

*** 4 bit ripple ***
.subckt RippleAdder_4bit A3 A2 A1 A0 B3 B2 B1 B0 Cin S3 S2 S1 S0 Cout VDD GND
XFullAdder1 A3 B3 C2 S3 Cout VDD GND FullAdder
XFullAdder2 A2 B2 C1 S2 C2 VDD GND FullAdder
XFullAdder3 A1 B1 C0 S1 C1 VDD GND FullAdder
XFullAdder4 A0 B0 Cin S0 C0 VDD GND FullAdder
.ends

*** state controller ***
.subckt State_ctrl POWER STORE CLK Is_state_1 Is_state_2 S1 S0 S1_ S0_ next_s0 next_s1 VDD GND
*S1S0_ S1_S0 come from encoder


XDFFs0 CLK next_s0 S0 S0_ VDD GND DFF
XDFFs1 CLK next_s1 S1 S1_ VDD GND DFF

Xnand1 Is_state_1 STORE s0_tmp VDD GND NAND2
XINV s0_tmp s0sel VDD GND INV

*Xand1 Is_state_1 STORE s0sel VDD GND AND2
Xor1 s0sel Is_state_2 s1sel VDD GND OR2

*XINV0 s0sel s0_tmp VDD GND INV

*XTG_MUXs0_1 VDD GND s0sel s0_tmp VDD GND TG_MUX
*XTG_MUXs0_2 GND s0_tmp POWER next_s0 VDD GND MUX
Xands0 s0_tmp  POWER next_s0 VDD GND AND2


*XTG_MUXs1_1 GND VDD s1sel s1_tmp VDD GND TG_MUX
*XTG_MUXs2_2 GND s1_tmp POWER next_s1 VDD GND MUX
Xands1 s1sel POWER   next_s1 VDD GND AND2
.ends

*** Display_ctrl controller ***
.subckt Display_ctrl S1 S0 MONEYIN3 MONEYIN2 MONEYIN1 MONEYIN0 TOTAL3 TOTAL2 TOTAL1 TOTAL0 M3 M2 M1 M0 VDD GND
*S1S0_ S1_S0 come from encoder
*Xbuffer3 S1_tmp S1 VDD GND  buffer
*Xbuffer2 S0_tmp S0 VDD GND  buffer
*Xbuffer1 M1_out M1 VDD GND  buffer
*Xbuffer0 M0_out M0 VDD GND  buffer

XMUX_M3_1 MONEYIN3 TOTAL3 S0 m3_tmp VDD GND MUX
*Xbuffer3 m3_tmp1 m3_tmp2 VDD GND buffer
*XMUX_M3_2 GND m3_tmp S1 M3 VDD GND MUX
Xand3 m3_tmp S1 M3 VDD GND AND2


XMUX_M2_1 MONEYIN2 TOTAL2 S0 m2_tmp VDD GND MUX
*XMUX_M2_2 GND m2_tmp S1 M2 VDD GND MUX
Xand2 m2_tmp S1 M2 VDD GND AND2

XMUX_M1_1 MONEYIN1 TOTAL1 S0 m1_tmp VDD GND MUX
*XMUX_M1_2 GND m1_tmp S1 M1 VDD GND MUX
Xand1 m1_tmp S1 M1 VDD GND AND2

XMUX_M0_1 MONEYIN0 TOTAL0 S0 m0_tmp VDD GND MUX
*XMUX_M0_2 GND m0_tmp S1 M0 VDD GND MUX
Xand0 m0_tmp S1 M0 VDD GND AND2

.ends

*** moneyin DFF ***
.subckt moneyin_DFF M3 M2 M1 M0 MONEYIN3 MONEYIN2 MONEYIN1 MONEYIN0 CLK VDD GND

XDFFMONEYIN3 CLK M3 MONEYIN3 MONEYIN3_ VDD GND DFF
XDFFMONEYIN2 CLK M2 MONEYIN2 MONEYIN2_ VDD GND DFF
XDFFMONEYIN1 CLK M1 MONEYIN1 MONEYIN1_ VDD GND DFF
XDFFMONEYIN0 CLK M0 MONEYIN0 MONEYIN0_ VDD GND DFF

.ends

*** total DFF ***
.subckt total_DFF  nexts1 nexts0 ADD3 ADD2 ADD1 ADD0 TOTAL3 TOTAL2 TOTAL1 TOTAL0 CLK VDD GND

XDFFTOTAL3 CLK next_TOTAL3 TOTAL3 TOTAL3_ VDD GND DFF
XDFFTOTAL2 CLK next_TOTAL2 TOTAL2 TOTAL2_ VDD GND DFF
XDFFTOTAL1 CLK next_TOTAL1 TOTAL1 TOTAL1_ VDD GND DFF
XDFFTOTAL0 CLK next_TOTAL0 TOTAL0 TOTAL0_ VDD GND DFF

XAND2 nexts1 nexts0 next_state_is_3 VDD GND AND2

XMUX3 TOTAL3 ADD3 next_state_is_3  next_TOTAL3 VDD GND MUX
XMUX2 TOTAL2 ADD2 next_state_is_3  next_TOTAL2 VDD GND MUX
XMUX1 TOTAL1 ADD1 next_state_is_3  next_TOTAL1 VDD GND MUX
XMUX0 TOTAL0 ADD0 next_state_is_3  next_TOTAL0 VDD GND MUX
.ends









*** main circuit ***
*XRippleAdder_4bit A3 A2 A1 A0 B3 B2 B1 B0 Cin S3 S2 S1 S0 Cout VDD GND RippleAdder_4bit
*Xonehot_encoder_2to4 S1 S0 S1_ S0_ OUT3 OUT2 OUt1 OUT0 VDD GND onehot_encoder_2to4
*XState_ctrl POWER STORE CLK S1 S0 S1_ S0_ OUT2 OUT1  VDD GND  State_ctrl
*XState_ctrl POWER STORE CLK OUT1 OUT2 S1 S0 S1_ S0_ next_s0 next_s1 VDD GND State_ctrl
*** input signal ***
*** DC ***
*Vhigh   VDD    0 dc 1.8v
*Vlow    GND    0 dc 0v

*** AC ***
* Clock signal with a 50% duty cycle at 100 MHz*
*VA0 CLK     0 pulse(0v 1.8v 0ns 1ps 1ps 10ns 20ns)
*VA1 POWER   0 pulse(1.8v 0v 5ns 1ps 1ps 80ns 160ns)
*VA2 STORE   0 pulse(1.8v 0v 5ns 1ps 1ps 40ns 80ns)
*VA3 s1_bar 0 pulse(1.8v 0v 0ns 1ps 1ps 40ns 80ns)
*VB0  B0 0 pulse(0v 1.8v 0ns 1ps 1ps 320ns 640ns)
*VB1  B1 0 pulse(0v 1.8v 0ns 1ps 1ps 640ns 1280ns)
*VB2  B2 0 pulse(0v 1.8v 0ns 1ps 1ps 1280ns 2560ns)
*VB3  B3 0 pulse(0v 1.8v 0ns 1ps 1ps 2560ns 5120ns)
* Data signal with a 50% duty cycle at 100 MHz, delayed by 5ns
*Vcin  Cin 0 pulse(0v 1.8v 0ns 1ps 1ps 5120ns 10240ns)


********************
**Simulation setting**
*.tran 0.1n 320n
*.measure tran power AVG POWER
**.meas TRAN Vmax MAX V(Q_) FROM=Rise2 TO=Fall2**
**.meas TRAN Vmin MIN V(Q_) FROM=Fall2 TO=Rise2**
*.end


***********************************************
