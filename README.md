# Vending-machine-design
This project is a Verilog RTL-based implementation of a configurable vending machine controller. It simulates a real vending system, supporting dynamic item setup, asynchronous user input, and real-time dispensing logic.

**Features**
Supports up to 1024 unique items
APB-like configuration interface (10 MHz)
Real-time operation mode on a 100 MHz system clock
Handles asynchronous currency and item select inputs (10 kHz – 50 MHz)
Dispenses items within 10 system clock cycles
Returns change if overpaid
Modular and clean RTL architecture
🔁 Operating Modes
1. Reset Mode
Initializes all internal memories and registers.
2. Configuration Mode
Item setup via APB-like interface:
Set total items
Configure item price
Set availability
Configuration data is safely synchronized from pclk to system_clk.
3. Operation Mode
Processes currency and item selection.
Compares inserted amount with item price.
Dispenses item and returns change if needed.
Ensures vending decision in under 10 cycles.
📂 Module Overview
fsm: Controls system mode transitions (Reset, Config, Operation)
cfg_block: Handles APB-based configuration and clock domain crossing
operation_controller: Performs runtime vending logic
vending_machine_top: Top-level integration and memory coordination
