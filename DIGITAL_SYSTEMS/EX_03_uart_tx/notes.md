# EX_03 — UART Transmitter

## Khái niệm
UART TX: 8N1 (8 data bits, no parity, 1 stop bit).
- IDLE: tx=1 (idle high), busy=0.
- START: tx=0 (start bit), busy=1.
- DATA: g?i 8 bit (LSB first).
- STOP: tx=1 (stop bit), busy=0.

## ?ng d?ng
- Serial communication.
- FPGA-to-PC communication.
- Sensor data transmission.
