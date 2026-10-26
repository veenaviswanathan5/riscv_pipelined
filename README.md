32-bit 5-Stage Pipelined RISC-V Processor (RV32I)
A 32-bit RISC-V processor core implementing the base integer (RV32I) instruction set. This project features a classic 5-stage pipeline architecture written in SystemVerilog, validated using a self-checking testbench.

Architecture Overview
The core is built with a meticulously routed 5-stage datapath (Instruction Fetch, Instruction Decode, Execute, Memory Access, and Write Back). To handle data and control dependencies, the architecture includes dedicated hardware logic for hazard mitigation and data forwarding.

Key Features:

ISA: RV32I Base Integer Instruction Set

Pipeline Stages: IF, ID, EX, MEM, WB

Hazard Management: Custom hazard detection unit and data forwarding to resolve Read-After-Write (RAW) data hazards and control hazards.

Component Modularity: Fully modular design down to foundational levels (custom ALUs, program counters, pipeline registers, and multiplexers).

Repository Structure
Plaintext
riscv_pipelined/
├── rtl/            # Register Transfer Level source files (SystemVerilog)
│   ├── design.sv          # Top-level RISC-V core wrapper
│   ├── alu.sv             # Arithmetic Logic Unit
│   ├── hazard.sv          # Hazard detection and forwarding unit
│   ├── *_reg.sv           # Pipeline stage registers (if_id, id_ex, ex_mem, mem_wb)
│   └── ...                # Other core components (control unit, PC, extenders, memory)
├── tb/             # Testbench files
│   └── testbench.sv       # Self-checking testbench for core validation
├── sim/            # Simulation output and waveform files (.vcd, .wlf, logs)
└── docs/           # Architecture diagrams and pipeline documentation (Coming Soon)

Development Environment
This project is developed and simulated in a dual-boot style WSL2 (Ubuntu) environment using:

IDE: Visual Studio Code

Languages: SystemVerilog

Initial Validation: EDA Playground

Future Roadmap
The architecture is designed to be extensible. Planned enhancements include:

Instruction Set Extension: Implementing the M-Extension for hardware multiplication and division.

Memory Hierarchy: Integration of an L1 Cache.

Bus Protocols: Wrapping the core with standard AXI bus interfaces.

Physical Design: Executing a complete RTL-to-GDSII flow using OpenLANE and the SkyWater 130nm PDK