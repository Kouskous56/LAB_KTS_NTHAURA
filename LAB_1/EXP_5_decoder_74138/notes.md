# EXP 5 ? f = Sigma(2,3,5,7) dung 74LS138

## Muc tieu
Cai dat ham Boolean dung decoder 3-to-8 (74LS138).

## Ham
f = Sigma(2,3,5,7) = ~x.y + x.z (rut gon)
Bang chan ly (Table 1.5): 0,0,1,1,0,1,0,1.

## Cach noi 74LS138
- A0=x, A1=y, A2=z (chan 1,2,3).
- Enable: E0=1 (chan 4), E1bar=0 (chan 5), E2bar=0 (chan 6).
- Q2bar,Q3bar,Q5bar,Q7bar o muc 0 tai cac minterm tuong ung.
- f = NAND(Q2bar,Q3bar,Q5bar,Q7bar).

## IC can dung
- 1 x 74LS138 + 1 x 74LS00 (NAND) hoac 74LS20 (NAND 4 dau vao).
