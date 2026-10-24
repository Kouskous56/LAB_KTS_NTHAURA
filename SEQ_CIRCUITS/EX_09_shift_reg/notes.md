# EX_09 — Shift register (serial in, parallel out)

## Khái niệm
Shift Register (SIPO): dữ liệu vào nối tiếp (serial in), đọc song song (parallel out).
- Mỗi cạnh lên clock: q = {q[6:0], si}.
- MSB vào trước, LSB vào sau.

## Ứng dụng
- IC 74LS164 (8-bit serial-in parallel-out shift register).
- Serial-to-parallel conversion.
- Data buffering.
