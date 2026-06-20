# Pattern Frequency Detector – FSM

A VHDL-based Finite State Machine (FSM) designed to detect and count non-overlapping occurrences of a 4-bit pattern within a 20-bit input data stream. The project was implemented using the industry-standard 3-process FSM architecture, separating the state register, next-state logic, and output logic to ensure clarity, maintainability, and correctness. The design was first modeled using an ASM chart and then translated into a 6-state FSM implementation with synchronous reset, start-signal control, and sliding-window pattern matching.

The project includes a comprehensive VHDL testbench with multiple test cases covering repeated patterns, mixed inputs, and no-match scenarios to verify the accuracy of the pattern counter. Simulation and validation were performed using EDA Playground while following digital design best practices, including synchronous design principles and proper separation of combinational and sequential logic.
