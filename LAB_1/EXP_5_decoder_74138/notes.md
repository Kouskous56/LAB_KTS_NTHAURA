# EXP 5 — f = Σ(2,3,5,7) dùng 74LS138 (Lab) + Prelab Q12: Σ(0,3,4,7)

## Mục tiêu
Cài đặt hàm Boolean dùng decoder 3-to-8 (74LS138).

## Hàm Lab (Exp 5)
f = Σ(2,3,5,7) = ~x.y + x.z (rút gọn)
Bảng chân lý (Table 1.5): 0,0,1,1,0,1,0,1.

## Hàm Prelab Q12
f = Σ(0,3,4,7) = y XNOR z (độc lập với x)
Bảng chân lý: 1,0,0,1,1,0,0,1.

## Cách nối 74LS138 (Lab version)
- A0=x, A1=y, A2=z (chân 1,2,3).
- Enable: E0=1 (chân 4), E1bar=0 (chân 5), E2bar=0 (chân 6).
- Q2bar,Q3bar,Q5bar,Q7bar ở mức 0 tại các minterm tương ứng.
- f = NAND(Q2bar,Q3bar,Q5bar,Q7bar).

## IC cần dùng
- 1 x 74LS138 + 1 x 74LS00 (NAND) hoặc 74LS20 (NAND 4 đầu vào).

## Lưu ý
- Prelab Q12 dùng f = Σ(0,3,4,7). Lab manual Experiment 5 ghi f = Σ(2,3,5,7).
- Hai biểu thức không tương đương. Code testbench kiểm tra CẢ HAI hàm.
- Top module dùng hàm Lab (Σ(2,3,5,7)).
