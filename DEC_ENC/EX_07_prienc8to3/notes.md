# EX_07 — Priority Encoder 8-to-3 (như 74LS148)

## Khái niệm
Priority Encoder 8-to-3 với input active-low (như 74LS148).
- Ưu tiên: i[7] > i[6] > ... > i[0].
- Output active-low sense (a = complement of binary code).
- gs_n (group select) = 0 khi có input active.
- eo_n (enable out) = 0 khi không có input active.

## Ứng dụng
- IC 74LS148 (8-to-3 priority encoder, active-low).
- Interrupt controller (chọn interrupt có ưu tiên cao nhất).
- Keyboard encoder.
