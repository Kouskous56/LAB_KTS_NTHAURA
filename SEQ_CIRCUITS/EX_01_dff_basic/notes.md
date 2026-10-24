# EX_01 — D Flip-Flop cơ bản (positive edge, async reset)

## Khái niệm
D Flip-Flop lưu giá trị đầu vào D tại cạnh lên của clock.
- Reset async (active low): q = 0 ngay khi rst_n=0.
- Tại cạnh lên clk: q = d.
- q_n = ~q (bổ sung).

## Ứng dụng
- Lưu trữ 1 bit dữ liệu.
- Register, pipeline.
- IC 74LS74 (dual D-FF).
