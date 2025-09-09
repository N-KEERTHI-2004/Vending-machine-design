# Vending Machine Controller (Verilog RTL)

This project is a **Verilog RTL-based implementation of a configurable vending machine controller**.  
It simulates a real vending system with support for **dynamic item setup, asynchronous user input, and real-time dispensing logic**.  
The design is modular, parameterized, and optimized for both configurability and fast operation.

---

##  Features
- Supports **up to 1024 unique items**  
- **APB-like configuration interface** running at 10 MHz  
- **Real-time operation mode** on a 100 MHz system clock  
- Handles **asynchronous currency and item select inputs** (10 kHz – 50 MHz)  
- Dispenses items within **10 system clock cycles**  
- **Returns change** if overpaid  
- Modular, scalable, and clean RTL architecture  

---

##  Operating Modes
1. **Reset Mode**  
   - Initializes all internal memories and registers  

2. **Configuration Mode**  
   - Item setup via APB-like interface:  
     - Set total items  
     - Configure item price  
     - Set availability  
   - Configuration data safely synchronized from `pclk` to `system_clk`  

3. **Operation Mode**  
   - Processes currency and item selection  
   - Compares inserted amount with item price  
   - Dispenses item and returns change if needed  
   - Ensures vending decision in under **10 cycles**  

---

##  Module Overview
- **main_controller** – Finite State Machine controlling mode transitions (`Reset → Config → Operation`)  
- **cfg_block** – Handles APB-style configuration interface and clock domain crossing  
- **currency_val** – Tracks currency insertion, availability, and reset on dispense  
- **item_memory** – Stores item info (ID, price, count, dispensed history) with runtime updates  
- **output_logic** – Manages dispense signal and change calculation  
- **vending_machine_top** – Top-level integration and memory coordination  
