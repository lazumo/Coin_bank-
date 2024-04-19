# Integrated Circuit Design Final Project

This is the documentation and related files for the Integrated Circuit Design course final project.

## File Description

- `110062118_賴姿妘_report.docx`: Project report in Word format
- `Coin_bank.txt`: HSPICE code for the Coin_bank circuit

## Circuit Design

The project designed a Coin Bank circuit, which consists of the following six modules:

1. State_ctrl: Composed of two DFFs and several MUXes, it performs state transitions based on the store and Power values. Responsible for state1 and state0 output.
2. Encoder: Converts the two-bit state representation into a one-hot form. Responsible for s3, s2, s1, and s0 output.
3. Total_DFF: Stores the total amount and includes a MUX that determines whether to update the new value based on the state_ctrl nextstate.
4. Money_DFF: Temporarily stores m3, m2, m1, and m0.
5. Ripple_adder: A 4-bit adder that performs operations on money_in and total_DFF.
6. Display_ctrl: Determines the output content based on the state from state_ctrl.

Please refer to the report document for detailed circuit diagrams and explanations.

## Simulation Results

- Pre-sim and Post-sim waveforms can be found in the report document.
- Screenshots of the DRC Summary Report and LVS passing message can be found in the report document.

## Layout

![image](https://github.com/lazumo/Coin_bank-/assets/63379847/149716b8-fdea-47b5-bd25-b6d6f9f4a0e5)
