# PREP 4 — IC Multiplexer 74LS151, f = Σ(1,2,4,7)

## Mục tiêu
Viết code SystemVerilog mô tả hoạt động của 74LS151 (8-to-1 MUX) và dùng nó
để triển khai hàm f(x,y,z) = Σ(1,2,4,7).

## 74LS151 — 8-to-1 Multiplexer

**Pinout (16 chân):**
- VCC = 16, GND = 8.
- Data inputs D0–D7: chân 4,3,2,1,15,14,13,12.
- Select A,B,C: chân 11,10,9 (C là MSB).
- Strobe (enable) Sbar: chân 7 (active LOW).
- Output Y: chân 5; W (đảo của Y): chân 6.

## Phân tích f = Σ(1,2,4,7)

- m1: 001 → x̄ȳz
- m2: 010 → x̄yz̄
- m4: 100 → xȳz̄
- m7: 111 → xyz

Dùng 74LS151: chọn C=x, B=y, A=z. Các đầu vào dữ liệu:
- D0 = 0, D1 = 1, D2 = 1, D3 = 0, D4 = 1, D5 = 0, D6 = 0, D7 = 1
- Strobe Sbar = 0 (enable).
- Output Y = f.

## Bảng chân lý

| x | y | z | f |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 0 | 1 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 |

## Bình luận / Nhận xét
- 74LS151 là IC đa năng: chỉ cần nối data input D0-D7 theo minterm (1 = VCC, 0 = GND) là có thể triển khai bất kỳ hàm 3 biến nào.
- Strobe Sbar phải nối GND để enable; nếu nối VCC thì output Y = 0, W = 1 (disabled).
- Output W là đảo của Y, có thể dùng nếu cần hàm phủ định.
