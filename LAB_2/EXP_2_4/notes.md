# EXP_2_4 ? MUX 74LS151: f = ?m(1,2,4,7)

## H?m
f = sum m(1,2,4,7) = x??z + x?y? + x?? + xyz.

## IC 74LS151 (8-to-1 MUX)
- Data input I = 8'b10010110 (I7..I0).
- Select S = {x, y, z} (C=x, B=y, A=z).
- Enable nG = 0 (GND).
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

## IC / c?ng
- 1 x 74LS151 (IC th?t trong Logisim).
- Module SystemVerilog: mux74ls151.sv (m? t? IC) + f_mux74ls151.sv (tri?n khai h?m).

## Pin (Nexys A7)
- SW[2]=x, SW[1]=y, SW[0]=z; LED[15]=f.

## B?nh lu?n
- 74LS151 l? IC ?a n?ng: ch? c?n n?i D0-D7 theo minterm (1=VCC, 0=GND) l? tri?n khai ???c b?t k? h?m 3 bi?n n?o.
- RTL Viewer s? cho th?y mux ???c t?ng h?p th?nh logic gates.
