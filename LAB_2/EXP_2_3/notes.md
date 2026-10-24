# EXP_2_3 ? H?nh 2.4: NOR + NAND

## M?ch
```
A = NOR(x, y?z)
B = NAND(~y, x)
F = NOR(A, B)
```

## Ph?n t?ch
Theo De Morgan: F = x?? (kh?ng ph? thu?c z).

## Truth table
x y z | F | Fs (r?t g?n)
0 0 0 | 0 | 0
0 0 1 | 0 | 0
0 1 0 | 0 | 0
0 1 1 | 0 | 0
1 0 0 | 1 | 1
1 0 1 | 1 | 1
1 1 0 | 0 | 0
1 1 1 | 0 | 0

## IC / c?ng
- 74LS02 (NOR, pinout ??c bi?t: output chan 1, inputs chan 2&3), 74LS00 (NAND), 74LS08 (AND), 74LS32 (OR).

## Pin (Nexys A7)
- SW[2]=x, SW[1]=y, SW[0]=z; LED[15]=F.

## B?nh lu?n
- Testbench ki?m tra c? d?ng g?c (NOR+NAND) v? d?ng r?t g?n (x&~y) cho kh?p nhau.
- RTL Viewer s? cho th?y m?ch ???c t?i gi?n th?nh x AND NOT(y).
