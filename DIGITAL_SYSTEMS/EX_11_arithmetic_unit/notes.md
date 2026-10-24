# EX_11 — Arithmetic Unit (AU) — Bộ Xử Lý Toán Học 4 Bit

## Khái niệm
Bộ xử lý toán học (Arithmetic Unit - AU) là mạch tổ hợp 4-bit thực hiện các phép toán
trên hai số nhị phân 4-bit (A và B) tùy theo 2 ngõ điều khiển S1, S0.

## Bảng chức năng

| S1 | S0 | Chức năng | Giải thích |
|----|----|-----------|------------|
| 0  | 0  | A + B     | A cộng B   |
| 0  | 1  | A + 1     | A cộng 1   |
| 1  | 0  | A - B     | A trừ B    |
| 1  | 1  | A - B - 1 | A trừ B trừ 1 |

## Thiết kế

### Quan hệ giữa full adder (x, y, Cin) và AU (A, B, S1, S0)

- **x = A** (luôn bằng A)
- **y = (B XOR S1) AND (S1 OR NOT S0)**
  - S1=0, S0=0: y = B (A+B)
  - S1=0, S0=1: y = 0 (A+1)
  - S1=1, S0=0: y = ~B (A-B)
  - S1=1, S0=1: y = ~B (A-B-1)
- **Cin = S0 XOR S1**
  - S1=0, S0=0: Cin=0
  - S1=0, S0=1: Cin=1
  - S1=1, S0=0: Cin=1
  - S1=1, S0=1: Cin=0

### Nguyên lý trừ (Two's Complement)
- A - B = A + ~B + 1 (Cin=1)
- A - B - 1 = A + ~B (Cin=0)

### Cấu trúc
- 4 full adder nối tiếp (ripple carry adder).
- Mỗi full adder nhận x_i=A_i, y_i=(B_i XOR S1)&(S1 OR ~S0), Cin từ carry trước.
- Output: F (4-bit tổng), Cout (carry out).

## Ứng dụng
- ALU (Arithmetic Logic Unit) trong CPU.
- Bộ xử lý toán học trong máy tính.
- Các mạch xử lý số trong FPGA.
