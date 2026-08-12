# RTL Design & Verification Assignment

This repository contains the RTL source code, SystemVerilog testbenches, and project documentation for the RTL and DV workflow assignment
## 📂 Repository Structure

The project directory is organized to separate initial designs, revised code, verification environments, and project documentation:

*   **`RTL(before day 7 )/`** — Initial RTL designs for the assignment modules.
    *   `seq_detect_1011.sv`: 1011 Sequence Detector module.
    *   `traffic_light.sv`: Traffic Light Controller module.
    *   `sync_fifo.sv`: Synchronous FIFO implementation.
*   **`RTL(revised after day 7 )/`** — Refactored and optimized RTL designs based on feedback and advanced concepts introduced after Day 7.
*   **`tb/`** — SystemVerilog smoke testbenches corresponding to each RTL module.
*   **`docs/`** — Project documentation and learning logs.
    *   `RTL_Specifications.docx`: Design specs and block diagrams.
    *   `Learning Document(Day1-11).docx`: Daily progress and theoretical learning notes.
    *   `Exercises(Day1-11).docx`: Solutions to daily assignments.
    *   `Day 13.docx`:
*   **`issues/`** — Tracking and debugging logs.
    *   `ISSUE_LOG.docx`: Documentation of bugs encountered during simulation and how they were resolved.

## 💻 Modules Overview

1.  **Sequence Detector (1011)**: A finite state machine (FSM) designed to detect the overlapping/non-overlapping sequence "1011" from a serial input stream.
2.  **Traffic Light Controller**: An FSM-based controller managing timing and state transitions for a standard traffic intersection.
3.  **Synchronous FIFO**: A First-In-First-Out memory buffer with parameterized depth and width, including full and empty flag generation.

## 🚀 How to Run (Simulation)

To run the smoke tests for these modules, navigate to the `tb/` directory and compile the specific testbench alongside the desired RTL version (either initial or revised). 

*(Add your specific simulation commands here, e.g., for ModelSim, VCS, or Verilator)*
