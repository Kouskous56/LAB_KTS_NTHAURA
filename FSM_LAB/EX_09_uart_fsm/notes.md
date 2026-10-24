# EX_09 — UART state machine

## Khái niệm
FSM cho UART TX: idle → start → data → stop.
- IDLE: tx=1 (idle high), busy=0.
- START: tx=0 (start bit), busy=1.
- DATA: g?i 8 bit data (LSB first).
- STOP: tx=1 (stop bit), busy=0.

## ?ng d?ng
- UART (Universal Asynchronous Receiver/Transmitter).
- Serial communication.
- Protocol state machine.
