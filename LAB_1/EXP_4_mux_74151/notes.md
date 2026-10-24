# EXP 4 — f = Σ(1,2,4,7) dùng 74LS151

## Mục tiêu
Cài đặt hàm Boolean dùng MUX 8-to-1 (74LS151).

## Hàm
f = Σ(1,2,4,7) (z là LSB)
Bảng chân lý (Table 1.4): 0,1,1,0,1,0,0,1.

## Cách nối 74LS151
- A2=x, A1=y, A0=z (chân 11,10,9).
- D0=0,D1=1,D2=1,D3=0,D4=1,D5=0,D6=0,D7=1.
- Strobe (chân 7) = 0 (enable).
- Output Y (chân 5) = f.

## IC cần dùng
- 1 x 74LS151.
