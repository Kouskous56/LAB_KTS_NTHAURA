# EXP_4 — Bộ đếm 0 đến 7 (ripple counter)

## Mô tả
Bộ đếm ripple 3 bit modulo 8 dùng 3 FF 74LS74, D=Qbar mỗi tầng.
- Q0 (LSB): clock ngoài.
- Q1: clock = Qbar0.
- Q2 (MSB): clock = Qbar1.

## Chuỗi đếm
000 → 001 → 010 → 011 → 100 → 101 → 110 → 111 → 000.

## IC
- 2 x 74LS74 (3 FF dùng, 1 FF thừa).
- Có thể thêm 74LS08/74LS00 cho enable/reset.

## Pin (Nexys A7)
- SW[0]=reset (active low), SW[1]=clock enable.
- LED[2:0] = Q2Q1Q0, LED[15]=overflow (rollover).

## Bình luận
- Mỗi tầng ripple nên có trễ lan truyền; đọc trạng thái sau khi ổn định.
- Testbench kiểm tra chuỗi đếm và reset.
