# EXP_2_1 ? Full Adder (Table 2.2)

## H?m
f = x'yz + (xy)'z + xy  (kh?ng r?t g?n, ??ng manual)
R?t g?n: f = xy + z  (theo testbench/README).

## Truth table (Table 2.2)
x y z | f
0 0 0 | 0
0 0 1 | 1
0 1 0 | 0
0 1 1 | 1
1 0 0 | 0
1 0 1 | 1
1 1 0 | 1
1 1 1 | 1

## IC / c?ng
- D?ng c?ng logic c? b?n (NOT, AND, OR). R?t g?n: 1?74LS08 (AND) + 1?74LS32 (OR).

## Pin (Nexys A7)
- SW[2]=x, SW[1]=y, SW[0]=z; LED[15]=f; LED[2:0] hi?n th? input.

## B?nh lu?n
- Testbench ki?m tra c? d?ng kh?ng r?t g?n v? d?ng r?t g?n cho kh?p nhau.
- RTL Viewer sau synthesis s? cho th?y m?ch ???c t?i gi?n th?nh xy + z.
