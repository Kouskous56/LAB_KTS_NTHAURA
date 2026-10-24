# EXP_2_3 — Hình 2.4 (NOR + NAND)

## Mạch
A = NOR(x, y·z)
B = NAND(~y, x)
F = NOR(A, B)

## Phân tích
Theo De Morgan: F = x·ư (không phụ thuộc z).

## Truth table
x y z | F | Fs (rút gọn)
0 0 0 | 0 | 0
0 0 1 | 0 | 0
0 1 0 | 0 | 0
0 1 1 | 0 | 0
1 0 0 | 1 | 1
1 0 1 | 1 | 1
1 1 0 | 0 | 0
1 1 1 | 0 | 0

## IC / cổng
- 74LS02 (NOR, pinout đặc biệt: output chân 1, inputs chân 2&3), 74LS00 (NAND), 74LS08 (AND), 74LS32 (OR).

## Pin (Nexys A7)
- SW[2]=x, SW[1]=y, SW[0]=z; LED[15]=F.

## Bình luận
- Testbench kiểm tra cả dạng gốc (NOR+NAND) và dạng rút gọn (x&~y) cho khớp nhau.
- RTL Viewer sau synthesis sẽ cho thấy mạch được tối giản thành x AND NOT(y).
