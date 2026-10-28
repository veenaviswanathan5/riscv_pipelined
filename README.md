# 32-bit 5-Stage Pipelined RISC-V Processor (RV32I)

A modular 32-bit RISC-V processor implementing the RV32I base integer instruction set, designed in SystemVerilog using a classic five-stage pipeline. The design incorporates hazard detection and data forwarding mechanisms and is validated using a self-checking testbench.

## Architecture Overview

The processor uses a five-stage pipeline to enable concurrent instruction execution.

| Stage | Name | Function |
|---|---|---|
| IF | Instruction Fetch | Fetches instructions using the program counter. |
| ID | Instruction Decode | Decodes instructions and reads source registers. |
| EX | Execute | Performs ALU operations, evaluates branches, and calculates addresses. |
| MEM | Memory Access | Performs data memory read and write operations. |
| WB | Write Back | Writes results back to the register file. |

## Key Features

- **ISA:** RV32I base integer instruction set.
- **Pipelined Architecture:** Five-stage IF, ID, EX, MEM, and WB datapath.
- **Hazard Detection:** Identifies data dependencies and inserts stalls where required.
- **Data Forwarding:** Reduces RAW (Read-After-Write) hazards by forwarding results between pipeline stages.
- **Control Hazard Handling:** Implements branch-related control logic.
- **Modular RTL:** Separate modules for the ALU, control unit, program counter, pipeline registers, multiplexers, immediate generators, and memory.
- **Functional Verification:** Self-checking SystemVerilog testbench.

## Repository Structure

```text
riscv_pipelined/
├── rtl/
│   ├── design.sv
│   ├── alu.sv
│   ├── hazard.sv
│   ├── *_reg.sv
│   └── ...
├── tb/
│   └── testbench.sv
├── sim/
│   └── Simulation logs and waveforms
└── docs/
    └── Architecture documentation
```

## Development Environment

- **Language:** SystemVerilog
- **IDE:** Visual Studio Code
- **Environment:** Ubuntu on WSL2
- **Initial Simulation:** EDA Playground
- **Verification:** Self-checking testbench and waveform analysis

## Verification

The processor is validated through simulation to evaluate instruction execution and pipeline behavior.

Test scenarios include:

- Arithmetic and logical operations
- Register read and write operations
- Load and store instructions
- Data hazard detection and forwarding
- Pipeline stalls and branch handling
- Instruction sequencing across pipeline stages

## Future Enhancements

- **RISC-V M-Extension:** Implement hardware multiplication and division.
- **L1 Cache:** Introduce instruction and data caches.
- **AXI Interface:** Integrate standard AXI bus interfaces.
- **Advanced Verification:** Add directed and randomized tests for corner cases and hazard-intensive instruction sequences.
- **RTL-to-GDSII Flow:** Explore synthesis and physical implementation using OpenLane and the SkyWater SKY130 PDK.

## Learning Outcomes

- Five-stage pipelined processor microarchitecture
- SystemVerilog RTL design and modular hardware development
- Data hazard detection, forwarding, and pipeline control
- Functional verification using self-checking testbenches
- Simulation-based debugging and waveform analysis
