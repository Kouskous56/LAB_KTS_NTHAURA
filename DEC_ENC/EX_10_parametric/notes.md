# EX_10 — Parametric decoder và encoder

## Khái niệm
Sử dụng parameter để tạo decoder/encoder tổng quát với N đầu vào/đầu ra.
- N phải là lũy thừa của 2 (2, 4, 8, 16, ...).
- Số bit select/input = $clog2(N).

## Ứng dụng
- Tái sử dụng code cho nhiều kích thước.
- FPGA: instantiate với N khác nhau trong cùng design.
- Software-defined hardware (parameterization).
