![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# TinyProcessor (`tt_um_TinyProcessor_naiyar`)

Welcome to **TinyProcessor**, a custom digital integrated circuit designed for physical silicon fabrication on the SkyWater 130nm process node via Tiny Tapeout!



## What is Tiny Tapeout?

[Tiny Tapeout](https://tinytapeout.com/) is an educational platform designed to make chip design and silicon fabrication accessible to students, hobbyists, and engineers worldwide. By aggregating multiple digital designs onto a single shared die, Tiny Tapeout enables custom silicon implementations to be manufactured through open-source ASIC flows like OpenLane and SkyWater's PDK.



## Why I Built This Project

My journey into chip design started during my second year as an Electrical Engineering student at McMaster University. Taking **ELECENG 2DI4 (Logic Design)** completely shifted how I viewed technology, it sparked a deep curiosity about how machines process information at the most fundamental transistor and gate levels. 

That passion also runs in my family. Growing up, my dad was deeply passionate about technology and even owned a computer store back home. Seeing his passion for computers inspired me from a young age to think deeply about how these systems function from the inside out. Building `TinyProcessor` and taking it all the way from Verilog RTL to actual silicon floorplanning has been an incredible hands-on journey to turn that curiosity into real hardware.



## System Overview & Technical Details

`TinyProcessor` is a command-driven micro-architecture featuring:
* A central controller FSM (`SYS_CTRL`) parsing multi-byte UART command protocols
* An 8-bit Arithmetic Logic Unit (ALU) supporting 14 arithmetic, logic, and comparison operations
* An 8x8 Register File for data staging and configuration
* Synchronous clocking and power-aware clock gating

> 📖 **For full technical specifications, architecture diagrams, command protocol tables, and instruction set details, please check out [`info.md`](./docs/info.md).**



## Quick Navigation

* **[`info.md`](./docs/info.md)** — Detailed system breakdown, ALU instruction set, and register mapping.
* **`docs/`** — Physical design layout screenshots (GDSII floorplan and 3D renders).
* **`test/`** — Cocotb simulation testbenches and GTKWave verification scripts.
* **`src/`** — Verilog Code.