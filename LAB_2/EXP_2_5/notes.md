# EXP_2_5 ? Decoder 74LS138: f = ?m(0,2,5,7)

## H?m
f = sum m(0,2,5,7) = x??? + x?y? + x?z + xyz.

## IC 74LS138 (3-to-8 Decoder)
- Address A = {x, y, z} (C=x, B=y, A=z).
- Enable: nEN2A = 0, nEN2B = 0, EN1 = 1.
- Outputs active LOW: Y0, Y2, Y5, Y7 xu?ng m?c 0 t?i c?c minterm t??ng ?ng.
- f = ~(Y0 & Y2 & Y5 & Y7) (d?ng 74LS08 (2 AND) + 74LS00 (1 NAND)).

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

## IC / c?ng
- 1 x 74LS138 + 1 x 74LS08 (AND) + 1 x 74LS00 (NAND).

## Pin (Nexys A7)
- SW[2]=x, SW[1]=y, SW[0]=z; LED[15]=f.

## B?nh lu?n
- 74LS138 l? decoder active-LOW: khi ???c enable, output t??ng ?ng minterm xu?ng m?c 0.
- ?? c? f = OR c?a c?c minterm, d?ng NAND c?c output active-low t??ng ?ng.
