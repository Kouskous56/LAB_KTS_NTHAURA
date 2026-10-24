# EXP_2_2 — F = Σm(0,1,3,4,7)

## Hàm
- Dạng tối giản (SOP): F = (Y·Z) + (~X·~Y) + (~Y·~Z) → f_exp2_2.sv
- Dạng tích phân (POS) tương đương: F = (Z + ~Y)·(Y + ~X + ~Z) → f_exp2_2_pos.sv

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

## IC / cổng
- Dạng SOP: 74LS04 (NOT), 74LS08 (AND), 74LS32 (OR).
- Dạng POS: tương đương, dùng NOR/OR.

## Pin (Nexys A7)
- SW[2]=X, SW[1]=Y, SW[0]=Z; LED[15]=F.

## Bình luận
- Hai dạng SOP và POS cho cùng kết quả logic (testbench kiểm tra cả hai).
- Dùng bìa Karnaugh để tối giản từ bảng chân lý.
