# EXP_1 — Full Adder (Bài 1, Lab 3)

## Hàm
S = A ⊕ B ⊕ Ci
Co = AB + ACi + BCi

## Truth table (Table 3.3)
A B Ci | S | Co
0 0 0 | 0 | 0
0 0 1 | 1 | 0
0 1 0 | 1 | 0
0 1 1 | 0 | 1
1 0 0 | 1 | 0
1 0 1 | 0 | 1
1 1 0 | 0 | 1
1 1 1 | 1 | 1

## IC / cổng
- 1 x 74LS86 (XOR), 1 x 74LS08 (AND), 1 x 74LS32 (OR).

## Pin (Nexys A7)
- SW[2]=A, SW[1]=B, SW[0]=Ci; LED[0]=S, LED[15]=Co.

## Bình luận
- Testbench kiểm tra cả 8 tổ hợp.
- RTL Viewer sau synthesis có thể tối giản khác sơ đồ cổng.
