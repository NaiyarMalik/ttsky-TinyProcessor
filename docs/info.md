<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

# TinyProcessor

## Overview

TinyProcessor is a compact UART-controlled processor designed in Verilog and implemented as an ASIC using the Tiny Tapeout open-source design flow. The processor executes a small instruction set through serial communication, allowing a host computer or microcontroller to control memory operations and arithmetic functions using UART commands.

The project was built to demonstrate the complete digital IC design workflow:

RTL design -> Verification -> synthesis -> place-and-route -> physical implementation on silicon.

## Features

 - 50MHz System Clock

 - 3.125MHz UART Clock (96000 Baud Rate) 

 - UART-controlled instruction interface
 
 - 8x8 bit register file
 
 - Arithmetic Logic Unit (ALU):
    - Addition
    - Subtraction
    - XOR
    - NOR
    - AND
    - OR
    - NAND
    - XNOR
    - Equal to
    - Less than
    - Greater than
    - Shift Right by 1 bit
    - Shift Left by 1 bit
 
 - Four supported processor commands:
        - Read Register
        - Write Register
        - ALU Operation with User Given Operands
        - ALU Operation with Present Register Memory

- Configurable UART baud-rate prescaler

- UART parity enable and parity type configuration

- Clock division and clock gating

- Reset synchronization

- Fully verified using Verilog Test Bench, Cocotb and GTKWave


## Schematics and Visuals

![alt text](image-1.png)

This is the Post-routing GDSII layout view of the custom digital ASIC design, showcasing standard cell placement, power ring/rail distribution, and multi-layer metal interconnect routing following physical design hardening and timing closure.

![alt text](image-2.png)

3D physical layout view of the custom TinyProcessor core implemented using the SkyWater 130nm PDK (sky130_fd_sc_hd). The visualization showcases the layered metal interconnects (met1–met5), standard cell placement, and vertical power straps rendered directly in the Tiny Tapeout 3D GDS viewer.

![System Schematic](image.png)

** Note: 
        
    - Tiny Tapeout only provides a single external clock, so we removed:
        - ❌ Asynchronous FIFO
        - ❌ Clock Domain Crossing (CDC) logic
        - ❌ data_sync
        - ❌ Separate UART clock domain

Everything now runs from the 50 MHz reference clock. **

## How it works

This project implements an integrated system that executes remote commands sent over a serial UART interface. The core consists of ten functional blocks distributed across two distinct clock domains: a high-speed reference clock domain (REF_CLK) and a standard communication clock domain (UART_CLK).  Incoming data frames received by the UART Receiver are synchronized and pushed to a system controller. This controller parses commands to perform either Register File reads/writes or arithmetic/logic operations using a built-in ALU. To handle the clock-domain crossing smoothly between processing and serialization, data results are buffered through an Asynchronous FIFO before being sent back to the master terminal via the UART Transmitter.

## How to test

## How to test

To test this project:

Clone the repository.
Run the provided testbench:

## External hardware

List external hardware used in your project (e.g. PMOD, LED display, etc), if any
