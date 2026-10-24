# EX_06 — Priority Encoder 4-to-2

## Khái niệm
Priority Encoder mã hóa đầu vào ưu tiên cao nhất thành mã nhị phân.
- Ưu tiên: d[3] > d[2] > d[1] > d[0].
- Output valid = 1 khi có ít nhất một input active.
- Nếu không có input active, valid = 0.

## Ứng dụng
- IC 74LS147 (10-to-4 priority encoder).
- Interrupt controller (chọn interrupt có ưu tiên cao nhất).
- Keyboard encoder.
