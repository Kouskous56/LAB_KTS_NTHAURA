# EXP_2 — Adder/Subtractor 4 bit

## Hàm
- Cộng: Result = A + B (C0=0)
- Trừ: Result = A + ~B + 1 (C0=1, bù hai)

## IC / cổng
- Cách 1: 4 full adder (2×74LS86, 2×74LS08, 1×74LS32) + 74LS86 (XOR cho B'=B⊕Sel).
- Cách 2: 1×74LS283 + 1×74LS86 (XOR cho B'=B⊕Sel).

## Lưu ý quan trọng
- Mâu thuẫn manual: một bước thủ tục yêu cầu nối C0 xuống GND.
  Cách chuẩn là C0=Sel. Xác nhận với giảng viên.
- C4=1 thường biểu thị không mượn (no borrow), C4=0 biểu thị có mượn.
- C4 không phải bit dấu của số có dấu.

## Pin (Nexys A7)
- SW[3:0]=A, SW[7:4]=B, SW[8]=Sel; LED[3:0]=S, LED[4]=Co.

## Bình luận
- Testbench kiểm tra 512 tổ hợp (16×16×2).
