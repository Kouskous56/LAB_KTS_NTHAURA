# Câu 12: f(x,y,z) = Σ(0,3,4,7) dùng 74LS138

**Phân tích:**
f = Σm(0,3,4,7)

**Dùng 74LS138 (3-to-8 decoder, output active LOW):**
- Nối A0 = x, A1 = y, A2 = z.
- Enable: E0 = 1, E1bar = 0, E2bar = 0.
- Output Q0bar, Q3bar, Q4bar, Q7bar sẽ ở mức 0 tại các minterm tương ứng.
- f = NOT(Q0bar AND Q3bar AND Q4bar AND Q7bar) (dùng cổng NAND 4 đầu vào, hoặc kết hợp NAND 2 đầu vào).

## Bảng chân lý
| x | y | z | f |
|---|---|---|---|
| 0 | 0 | 0 | 1 |
| 0 | 0 | 1 | 0 |
| 0 | 1 | 0 | 0 |
| 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 1 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 |

**IC cần dùng:** 1 x 74LS138 + 1 x 74LS00 (NAND) hoặc 74LS20 (NAND 4 đầu vào).

## Lưu ý
- Prelab Q12 dùng f = Σ(0,3,4,7). Lab manual Experiment 5 ghi f = Σ(2,3,5,7).
- Hai biểu thức không tương đương. Xác nhận với giảng viên trước khi lắp mạch.
- Sổ tay kỹ thuật cũng ghi sự khác biệt này ở mục 7, Experiment 5.
