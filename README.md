# fifo-with-assertions
Designed an 8-bit synchronous FIFO in SystemVerilog with configurable depth, read/write pointers, occupancy tracking, and full/empty status flags. Implemented SystemVerilog assertions to detect invalid read/write operations and developed a testbench to verify FIFO data ordering and control logic.
# FIFO with SystemVerilog Assertions

## Overview

This project implements an 8-bit synchronous FIFO (First In, First Out) using SystemVerilog.

The FIFO stores data temporarily and ensures that the first data written is the first data read. The design uses write and read pointers, an occupancy counter, and full/empty status flags.

SystemVerilog assertions are included to detect invalid FIFO operations and verify important design conditions.

---

## Main Functions

### FIFO

- Stores 8-bit data values
- Supports synchronous write and read operations
- Maintains separate read and write pointers
- Tracks the number of stored elements
- Generates `full` and `empty` status flags
- Prevents writing when the FIFO is full
- Prevents reading when the FIFO is empty

### SystemVerilog Assertions

Assertions are used to check important FIFO conditions during simulation:

- Detect write attempts when FIFO is full
- Detect read attempts when FIFO is empty
- Check FIFO empty condition during reset
- Check that FIFO count does not exceed its configured depth

---

## FIFO Concept

FIFO stands for **First In, First Out**.

The first data written into the FIFO is the first data read from it.

```text
Write
  │
  ▼
┌─────────────────────────────┐
│  10  │  20  │  30  │  40  │
└─────────────────────────────┘
  │
  ▼
Read → 10 → 20 → 30 → 40

Data Flow
                 Write Data
                     │
                     ▼
              ┌─────────────┐
              │             │
              │    FIFO     │
              │             │
              └─────────────┘
                     │
                     ▼
                 Read Data

               ┌─────────────────────┐
               │        FIFO         │
               │                     │
wr_data ──────►│  Memory             │
               │      ▲              │
               │      │              │
               │  Write Pointer      │
               │                     │
               │  Read Pointer       │
               │                     │
               │  Count              │
               │                     │
               └──────────┬──────────┘
                          │
                          ▼
                       rd_data

---

## Key Features

- 8-bit data width
- 8-entry FIFO depth
- Synchronous read and write operations
- Separate read and write pointers
- FIFO occupancy counter
- Full and empty status flags
- Protection against invalid read/write operations
- SystemVerilog Assertions (SVA)
- Dedicated SystemVerilog testbench
- Parameterized data width and FIFO depth
- RTL simulation using AMD Vivado

---

## Main Functions

### FIFO Data Storage

The FIFO contains memory locations used to temporarily store incoming data.

### Write Operation

When `wr_en` is HIGH and the FIFO is **not full**, the input data is written to the memory location pointed to by the write pointer.

### Read Operation

When `rd_en` is HIGH and the FIFO is **not empty**, data is read from the memory location pointed to by the read pointer.

### FIFO Status

The FIFO monitors the number of stored elements using an occupancy counter.

```text
count = 0           → FIFO EMPTY
count = FIFO_DEPTH  → FIFO FULL
