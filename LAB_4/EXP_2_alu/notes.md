# EXP_2 — ALU 4 bit

## Mục tiêu
Cài đặt ALU 4-bit với 4 phép toán.

## Đặc tả
- Mapping: `A[3:0]=SW[3:0]`, `B[3:0]=SW[7:4]`, `Sel[1:0]=SW[9:8]`, `S[3:0]=LED[3:0]`, `Co=LED[4]`.

| Sel | Chức năng | S[3:0] |
|:---:|---|---|
| 00 | A+B | tổng modulo 16 |
| 01 | A−B | hiệu modulo 16 |
| 10 | A AND B | từng bit AND |
| 11 | A OR B | từng bit OR |

## Quy ước cỗ Co
- Phép cộng: bit carry thứ năm.
- Phép trừ: carry-out của `A+~B+1` (1=no borrow).
- Phép logic: Co=0.
- Gán Co ở mọi nhánh, không để mặc định ngầm.

## Phép thử tối thiểu
Cộng có carry (`15+1`), không carry, A=B khi trừ (hiệu 0, no-borrow),
A<B (borrow), và vài vector xác nhận bitwise AND/OR.
Bảng chân trị toàn diện có 16×16×4=1024 tổ hợp.

## Pin (Nexys A7)
- SW[3:0]=A, SW[7:4]=B, SW[9:8]=Sel; LED[3:0]=S, LED[4]=Co.
