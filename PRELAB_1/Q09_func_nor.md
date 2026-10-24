# Câu 9: f = Σm(1,3,6) dùng NOR 2 đầu vào

**Từ Câu 8:** f = x̄z + xyž.

**Dạng POS (tích các tổng):**
f = (x + y + z)(x + ȳ + z)(x̄ + y + z)(x̄ + y + ž)(x̄ + ȳ + ž)

**Chuyển sang NOR:**
Mỗi tổng (OR) có thể tạo bằng NOR + inverter; tích các tổng tạo bằng NOR của các
tổng đảo. Dùng 74LS02 (NOR) và 74LS04 (NOT) để hoàn thành.

**Số lượng IC:** Cần 2-3 x 74LS02 (4 cổng NOR mỗi IC) + 74LS04 (inverter).

**Bảng chân lý (f = Σm(1,3,6)):**
| x | y | z | f |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 0 |
| 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 1 |
| 1 | 1 | 1 | 0 |

Lưu ý: Không nhầm với biểu thức rút gọn của Câu 7 (x̄y + yz).
