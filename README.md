# Traffic Light Controller (TLC) using Finite State Machine (FSM) - Verilog

## Overview

This project implements a Traffic Light Controller (TLC) using a Finite State Machine (FSM) in Verilog HDL. The controller manages traffic flow for three roads by allowing only one road to have a green signal at a time while the other two remain red.

The design cycles through Green → Yellow → Green → Yellow transitions for each road in a fixed sequence.

---

## Features

- Three-road traffic control system
- FSM-based implementation
- Green and Yellow timing control
- Asynchronous active-HIGH reset
- Fully synthesizable RTL design
- Simple and scalable architecture

---

## Signal Description

### Inputs

| Signal | Width | Description |
|----------|--------|-------------|
| clk_i | 1 | System clock |
| rst_i | 1 | Active HIGH asynchronous reset |

### Outputs

| Signal | Width | Description |
|----------|--------|-------------|
| light_o | 9 | Traffic light outputs |

---

## Light Encoding

Output format:

```text
(R1 Y1 G1 R2 Y2 G2 R3 Y3 G3)
```

### Light Patterns

| State | Output | Meaning |
|---------|----------|---------|
| G1R2R3 | 001100100 | Road 1 Green, Roads 2 & 3 Red |
| Y1R2R3 | 010100100 | Road 1 Yellow, Roads 2 & 3 Red |
| R1G2R3 | 100001100 | Road 2 Green, Roads 1 & 3 Red |
| R1Y2R3 | 100010100 | Road 2 Yellow, Roads 1 & 3 Red |
| R1R2G3 | 100100001 | Road 3 Green, Roads 1 & 2 Red |
| R1R2Y3 | 100100010 | Road 3 Yellow, Roads 1 & 2 Red |

---

## State Definitions

| State | Description |
|---------|-------------|
| S1 | Road 1 Green |
| S2 | Road 1 Yellow |
| S3 | Road 2 Green |
| S4 | Road 2 Yellow |
| S5 | Road 3 Green |
| S6 | Road 3 Yellow |

---

## Timing Parameters

```verilog
green  = 45;
yellow = 5;
```

### State Durations

| State Type | Duration |
|------------|----------|
| Green | 45 Clock Cycles |
| Yellow | 5 Clock Cycles |

---

## State Transition Sequence

```text
S1 → S2 → S3 → S4 → S5 → S6 → S1
```

Detailed sequence:

```text
Road1 Green
      ↓
Road1 Yellow
      ↓
Road2 Green
      ↓
Road2 Yellow
      ↓
Road3 Green
      ↓
Road3 Yellow
      ↓
Repeat
```

---

## FSM Operation

### Reset Condition

When reset is asserted:

```verilog
state <= S1;
timer <= 0;
```

The controller starts with:

```text
Road 1 = Green
Road 2 = Red
Road 3 = Red
```

---

### Timer Operation

A 6-bit counter tracks the duration of each state.

```verilog
timer <= timer + 1;
```

When the required count is reached:

```verilog
state <= next_state;
timer <= 0;
```

---

## Output Logic

The output depends only on the current state.

Example:

```verilog
assign light_o = (state == S1)? G1R2R3 :
                 (state == S2)? Y1R2R3 :
                 (state == S3)? R1G2R3 :
                 (state == S4)? R1Y2R3 :
                 (state == S5)? R1R2G3 :
                 (state == S6)? R1R2Y3 :
                                G1R2R3;
```

---

## Testbench Description

The testbench performs:

- Clock generation
- Reset verification
- Long-duration simulation
- State monitoring
- Color monitoring
- Waveform generation

---

## Clock Generation

```verilog
initial begin
   clk_ti = 1'b0;
   forever #5 clk_ti = ~clk_ti;
end
```

Clock period:

```text
10 Time Units
```

---

## Reset Sequence

```verilog
rst_ti = 1'b1;
#13 rst_ti = 1'b0;
```

A second reset is applied later to verify recovery behavior.

---

## Sample Simulation Output

```text
Time: 25 | Timer: 1 | State: 1 | Output: 001100100
Colors are:
G1 R2 R3

Time: 475 | Timer: 0 | State: 2 | Output: 010100100
Colors are:
Y1 R2 R3

Time: 525 | Timer: 0 | State: 3 | Output: 100001100
Colors are:
R1 G2 R3
```

---

## State Flow Example

```text
S1 (Road1 Green)
      |
      v
S2 (Road1 Yellow)
      |
      v
S3 (Road2 Green)
      |
      v
S4 (Road2 Yellow)
      |
      v
S5 (Road3 Green)
      |
      v
S6 (Road3 Yellow)
      |
      v
S1 (Repeat)
```

---

## Waveform

Generated waveform file:

```text
TLC.vcd
```

Open with GTKWave:

```bash
gtkwave TLC.vcd
```

---

## How to Run (Icarus Verilog)

### Compile

```bash
iverilog -o TLC TLC.v
```

### Run Simulation

```bash
vvp TLC
```

### Open Waveform

```bash
gtkwave TLC.vcd
```

---

## Applications

- Smart traffic intersections
- Digital control systems
- FPGA-based traffic management
- FSM learning and verification
- Embedded traffic controllers

---

## Notes

- Only one road receives a Green signal at a time.
- Yellow signal provides transition time before switching roads.
- The controller continuously cycles through all roads.
- Timing values can be modified easily through parameters.
- The design is fully synthesizable and FPGA compatible.

---
