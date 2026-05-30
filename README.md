# 8-Bit Programmable Delay Line (PDL)

## Overview

This project implements an 8-Bit Programmable Delay Line (PDL) in Verilog HDL inspired by the architecture and functionality of the Data Delay Devices 3D3418 Programmable Delay Line.

The design supports both serial and parallel delay programming modes and allows dynamic control of output delay using an 8-bit programmable value. The programmed delay value is stored internally and used to introduce a variable propagation delay between the input and output signals.

The architecture integrates multiple shift register structures including:

- Serial In Serial Out (SISO)
- Serial In Parallel Out (SIPO)
- Parallel In Serial Out (PISO)
- Parallel In Parallel Out (PIPO)

to emulate the serial and parallel programming interfaces found in commercial programmable delay line devices.

The project includes RTL design, functional verification using a testbench, simulation waveform generation, logic synthesis, and synthesized RTL schematics.

The functionality and programming methodology were studied using the Data Delay Devices 3D3418 Programmable Delay Line datasheet.

Reference Datasheet: :contentReference[oaicite:0]{index=0}

---

## Design Specifications

- 8-Bit Programmable Delay Value
- Serial Programming Interface
- Parallel Programming Interface
- Programmable Output Delay
- Address Enable Control
- Mode Selection Logic
- Serial Data Input and Output
- Configurable Delay Generation
- Shift Register Based Architecture

---

## Tools Used

- Quartus II for RTL Design and Logic Synthesis
- ModelSim-Altera for Simulation and Waveform Generation
- Verilog HDL

---

## Features

- Serial and parallel programming modes
- Dynamic delay value configuration
- Programmable delay generation
- Address enable controlled delay updates
- Serial data shifting and retrieval
- Parallel data loading and retrieval
- Modular architecture using shift registers
- Behaviour inspired by commercial programmable delay line devices
- Functional verification through simulation

---

## RTL Design Description

The Programmable Delay Line is composed of multiple functional blocks working together to configure and generate programmable signal delays.

### Internal Modules

#### SISO Register
Used for serial data transmission and serial output generation.

#### PISO Register
Used for parallel data loading and serial readback functionality.

#### SIPO Register
Used for receiving serial programming data and converting it into parallel format.

#### PIPO Register
Used for storing parallel programming values.

#### Address Latch

The programmed delay value is captured when the Address Enable (`AE`) signal becomes active.

#### Delay Generation Block

The delay block calculates the output delay using:

```text
Delay = Offset + (Programmed Value × Step Size)
```

Implemented parameters:

```text
Offset = 10
Step Size = 2
```

The output signal is reproduced after the calculated delay interval.

---

## Functional Description

The design operates in two programming modes.

### Parallel Programming Mode

When:

```text
MD = 1
```

- Delay value is applied through the 8-bit parallel input bus.
- PIPO register captures the delay value.
- Address Enable signal stores the selected delay setting into the internal latch.

### Serial Programming Mode

When:

```text
MD = 0
```

- Delay value is entered serially through the SI input.
- SIPO register assembles the incoming serial bits.
- Address Enable signal transfers the received value into the delay latch.

### Serial Output Functionality

The design also supports readback operation:

- SISO path used in serial mode
- PISO path used in parallel mode

The selected serial output is available through the SO pin.

---

## Delay Generation

The delay module reproduces the input signal at the output after a programmable delay interval.

### Rising Edge Behaviour

- Delay value is calculated using the programmed address.
- Output transitions HIGH after the computed delay.

### Falling Edge Behaviour

- Delay value is recalculated.
- Output transitions LOW after the computed delay.

This emulates the behaviour of a programmable digital delay line.

---

## Testbench Verification

The testbench verifies:

- Reset functionality
- Parallel programming mode
- Serial programming mode
- Address enable operation
- Delay value storage
- Delay generation
- Serial output functionality
- SISO data path
- PISO data path
- Input-to-output timing behaviour

### Test Scenarios

#### Parallel Mode Without Address Enable
Verifies that delay settings are not latched.

#### Parallel Mode With Address Enable
Verifies successful delay value capture.

#### Serial Mode Without Address Enable
Verifies serial data loading behaviour.

#### Serial Mode With Address Enable
Verifies serially programmed delay updates.

#### Serial Output Verification
Verifies both:
- SISO output path
- PISO output path

Simulation is performed using ModelSim-Altera.

---

## Simulation Results

Waveform analysis confirms:

- Correct serial programming operation
- Correct parallel programming operation
- Proper address enable functionality
- Accurate delay value storage
- Successful programmable delay generation
- Proper serial data output behaviour
- Correct mode switching operation

---

## Synthesis Results

Logic synthesis is performed using Quartus II.

Synthesis outputs include:

- RTL schematic
- Logic synthesis report

---

## Datasheet Reference

The architecture and programming methodology were studied using the following device datasheet:

### Data Delay Devices 3D3418

Key features referenced:

- 8-bit programmable delay control
- Serial programming interface
- Parallel programming interface
- Address enable functionality
- Programmable delay generation
- Serial data readback support

---

## Applications

- Digital timing control
- Clock alignment systems
- Signal synchronization
- Delay compensation circuits
- FPGA prototyping
- Communication systems
- Test and measurement equipment
- Timing calibration systems

---

## Author

Shaan Garg
