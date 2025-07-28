# Avoid Clash – FPGA Game in VHDL 🎮

## Project Description

**Avoid Clash** is an arcade-style game developed in **VHDL** and implemented on a **Terasic DE10-Lite FPGA board**. The goal of the game is simple: move a paddle to avoid falling obstacles. The player can move only horizontally using a joystick. The score increases over time, while collisions with obstacles cause the player to lose lives.

This project demonstrates how it is possible to develop interactive games directly on an FPGA using VHDL, taking advantage of VGA output, joystick input, clock dividers, pseudo-random number generators (LFSR), and 7-segment displays.

---

## Hardware Used

- **FPGA Board**: Terasic DE10-Lite (Intel MAX 10)
- **Analog Joystick**
- **VGA Monitor** (connected via VGA cable)
- **7-Segment Displays** (integrated on the board)
- **LEDs** to indicate player lives

---

## Software

- **Intel Quartus Prime Lite Edition**
- Language: **VHDL**
- Simulation and synthesis are performed directly in the Quartus environment

---

## How the Game Works

- The game starts with 3 lives.
- One point is added for every second of survival.
- Obstacles fall with increasing speed and are controlled by a pseudo-random number generator (LFSR).
- If the paddle hits an obstacle, the player loses one life.
- The game ends when:
  - **100 points** are reached → WIN (green screen).
  - All lives are lost → GAME OVER (red screen).
- The current score is shown on three 7-segment displays.
- The game can be restarted using a switch on the board (reset).

---

## Project Contents

The repository is organized as follows:
- **Code folder**: contains all the VHDL source code of the project
- **PinPlanner.csv**: a file listing all the pin assignments used in the project, essential to replicate the FPGA setup
- **Report.pdf**: detailed documentation useful for reproducing and understanding the game logic

