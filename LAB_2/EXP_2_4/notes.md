# EXP_2_4 — MUX 74LS151

## Hàm
f = sum m(1,2,4,7) = x̄ȳz + x̄yz̄ + xưȳz̄ + xyz.

## IC 74LS151 (8-to-1 MUX)
- Data input I = 8'b10010110 (I7..I0).
- Select S = {x,y,z} tức C=x, B=y, A=z.
- Enable E tích cực mức thấp (nối GND).
- Output Y = f, W = fbar.

## Truth table
x y z | f
0 0 0 | 0
0 0 1 | 1
0 1 0 | 1
0 1 1 | 0
1 0 0 | 1
1 0 1 | 0
1 1 0 | 0
1 1 1 | 1

## IC / cổng
- 1 x 74LS151 (IC thật trong Logisim).
- Module SystemVerilog: mux74ls151.sv (mô tả IC) + f_mux74ls151.sv (triển khai hàm).

## Pin (Nexys A7)
- SW[2]=x, SW[1]=y, SW[0]=z; LED[15]=f.

## Bình luận
- 74LS151 là IC đa năng: chỉ cần nối data input D0-D7 theo minterm (1=VCC, 0=GND) là triển khai được bất kỳ hàm 3 biến nào.
- Strobe Sbar phải nối GND để enable.
- Output W là đảo của Y, có thể dùng nếu cần hàm phủ định.
