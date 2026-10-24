# PREP 5 — IC Decoder 74LS138, f = Σ(0,2,5,7)

## Mục tiêu
Viết code SystemVerilog mô tả hoạt động của 74LS138 (3-to-8 decoder) và dùng nó
để triển khai hàm f(x,y,z) = Σ(0,2,5,7).

## 74LS138 — 3-to-8 Decoder/Demultiplexer

**Pinout (16 chân):**
- VCC = 16, GND = 8.
- Address A0, A1, A2: chân 1, 2, 3 (A0 là LSB).
- Enable: E0 (active HIGH) = chân 4, E1bar (active LOW) = chân 5, E2bar (active LOW) = chân 6.
- Outputs Q0..Q7 (active LOW): chân 15, 14, 13, 12, 11, 10, 9, 7.

## Phân tích f = Σ(0,2,5,7)

- m0: 000 → Q0bar = 0
- m2: 010 → Q2bar = 0
- m5: 101 → Q5bar = 0
- m7: 111 → Q7bar = 0

Vì output active LOW, để có f = 1 tại các minterm này:
f = NOT( Q0bar AND Q2bar AND Q5bar AND Q7bar )
(dùng cổng NAND 4 đầu vào, hoặc kết hợp NAND 2 đầu vào).

## Bảng chân lý

| x | y | z | f |
|---|---|---|---|
| 0 | 0 | 0 | 1 |
| 0 | 0 | 1 | 0 |
| 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 |

## Bình luận / Nhận xét
- 74LS138 là decoder active-LOW: khi được enable, output tương ứng minterm xuống mức 0, các output khác ở mức 1.
- Để có f = OR của các minterm, dùng NAND các output active-low tương ứng.
- Nếu cần enable/disable decoder, điều khiển E0 (active HIGH) hoặc E1bar/E2bar (active LOW).

## Lưu ý
- Prelab Q12 dùng f = Σ(0,3,4,7). Lab manual Experiment 5 ghi f = Σ(2,3,5,7).
- Hai biểu thức không tương đương. Xác nhận với giảng viên trước khi lắp mạch.
- Sổ tay kỹ thuật cũng ghi sự khác biệt này ở mục 7, Experiment 5.
