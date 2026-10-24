# EXP_2_5 — Decoder 74LS138

## Hàm
f = sum m(0,2,5,7) = x̄ȳz̄ + x̄yz̄ + xȳz + xyz.

## IC 74LS138 (3-to-8 Decoder)
- Address A = {x, y, z} (C=x, B=y, A=z).
- Enable: nEN2A = 0, nEN2B = 0, EN1 = 1.
- Outputs active LOW: Y0, Y2, Y5, Y7 xuống mức 0 tại các minterm tương ứng.
- f = ~(Y0 & Y2 & Y5 & Y7) (dùng 74LS08 (2 AND) + 74LS00 (1 NAND)).

## Truth table
x y z | f
0 0 0 | 1
0 0 1 | 0
0 1 0 | 1
0 1 1 | 0
1 0 0 | 0
1 0 1 | 1
1 1 0 | 0
1 1 1 | 1

## IC / cổng
- 1 x 74LS138 + 1 x 74LS08 (AND) + 1 x 74LS00 (NAND).

## Pin (Nexys A7)
- SW[2]=x, SW[1]=y, SW[0]=z; LED[15]=f.

## Bình luận
- 74LS138 là decoder active-LOW: khi được enable, output tương ứng minterm xuống mức 0.
- Để có f = OR của các minterm, dùng NAND các output active-low tương ứng.
