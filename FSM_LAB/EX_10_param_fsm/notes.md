# EX_10 — Parametric FSM

## Khái niệm
FSM tổng quát với N trạng thái (parameter).
- N phải là lũy thừa của 2 (2, 4, 8, 16, ...).
- State encoding: binary, log2(N) bit.
- Output z = 1 khi ở trạng thái cuối (N-1).

## Ứng dụng
- Tái sử dụng code cho nhiều FSM.
- FPGA: instantiate với N khác nhau.
- Software-defined hardware (parameterization).
