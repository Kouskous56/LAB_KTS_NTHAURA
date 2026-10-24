# EXP 1 ? Boolean function f(x,y,z) = xbar.y + ybar.z

## Muc tieu
Cai dat ham Boolean dang AND-OR va dang chi dung NAND.

## IC can dung (AND-OR)
- 1 x 74LS04 (NOT), 1 x 74LS08 (AND), 1 x 74LS32 (OR).

## Dang NAND
- 5 cong NAND 2 dau vao -> 2 x 74LS00.
- xbar = x NAND x; ybar = y NAND y; a = xbar NAND y; b = ybar NAND z; f = a NAND b.

## Bang chan ly
x y z | f
0 0 0 | 0
0 0 1 | 1
0 1 0 | 1
0 1 1 | 1
1 0 0 | 0
1 0 1 | 1
1 1 0 | 0
1 1 1 | 0
f = Sigma(1,2,3,5) (z la LSB).

## Pinout (Nexys A7)
- SW[2]=x, SW[1]=y, SW[0]=z; LED[0]=f.
