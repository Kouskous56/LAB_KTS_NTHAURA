# EXP_2_2 ? F = ?m(0,1,3,4,7)

## H?m
- SOP: F = (Y?Z) + (~X?~Y) + (~Y?~Z)  ?  f_exp2_2.sv
- POS: F = (Z + ~Y)?(Y + ~X + ~Z)  ?  f_exp2_2_pos.sv

## Truth table (Table 2.3)
X Y Z | F
0 0 0 | 1
0 0 1 | 1
0 1 0 | 0
0 1 1 | 1
1 0 0 | 1
1 0 1 | 0
1 1 0 | 0
1 1 1 | 1

## IC / c?ng
- D?ng SOP: 74LS04 (NOT), 74LS08 (AND), 74LS32 (OR).
- D?ng POS: t??ng ???ng, d?ng NOR/OR.

## Pin (Nexys A7)
- SW[2]=X, SW[1]=Y, SW[0]=Z; LED[15]=F.

## B?nh lu?n
- Hai d?ng SOP v? POS cho c?ng k?t qu? logic (testbench ki?m tra c? hai).
- D?ng b?a Karnaugh ?? t?i gi?n t? b?ng ch?n l?.
