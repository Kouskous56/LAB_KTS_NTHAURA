# Câu 8: f(x,y,z) = Σm(1,3,6) (SOP form)

**Minterm (z là LSB):**
- m1: x=0,y=0,z=1 → x̄ȳz
- m3: x=0,y=1,z=1 → x̄yz
- m6: x=1,y=1,z=0 → xyž

**SOP form:**
F = x̄ȳz + x̄yz + xyž

**Rút gọn:**
F = x̄z(ȳ + y) + xyž = x̄z + xyž

**IC cần dùng:**
- 74LS04 (NOT): tạo x̄, ž (nếu cần).
- 74LS08 (AND): tạo x̄z và xyž (cần 2 cổng AND 2 đầu vào, nhưng xyž cần 3 đầu vào → dùng 2 cổng AND).
- 74LS32 (OR): cộng hai tích.

**Tổng: 1 x 74LS04, 1 x 74LS08, 1 x 74LS32.**

Bảng chân lý:

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

f = Σm(1,3,6) (z là LSB).
