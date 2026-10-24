# EXP 1 — Boolean function f(x,y,z) = x̄y + yz

## Mục tiêu
Cài đặt hàm Boolean dạng AND-OR và dạng chỉ dùng NAND.

## IC cần dùng (AND-OR)
- 1 x 74LS04 (NOT): dùng 1 cổng NOT để tạo x̄.
- 1 x 74LS08 (AND): dùng 2 cổng AND để tạo x̄y và yz.
- 1 x 74LS32 (OR): dùng 1 cổng OR để cộng hai tích.

## Dạng NAND
- 4 cổng NAND 2 đầu vào -> 1 x 74LS00.
- x̄ = x NAND x; a = x̄ NAND y; b = y NAND z; f = a NAND b.

## Bảng chân lý
x y z | f
0 0 0 | 0
0 0 1 | 0
0 1 0 | 1
0 1 1 | 1
1 0 0 | 0
1 0 1 | 0
1 1 0 | 0
1 1 1 | 1

f = Σm(2,3,7) (z là LSB).

## Pinout (Nexys A7)
- SW[2]=x, SW[1]=y, SW[0]=z; LED[0]=f.
