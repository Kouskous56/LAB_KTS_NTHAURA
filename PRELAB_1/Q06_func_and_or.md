# Câu 6: f(x,y,z) = x̄y + yz (AND-OR)

**Hàm:** f = NOT(x) AND y OR y AND z = y · (x̄ + z)

**IC cần dùng:**
- 1 x 74LS04 (6 NOT): dùng 1 cổng NOT để tạo x̄.
- 1 x 74LS08 (4 AND): dùng 2 cổng AND để tạo x̄y và yz.
- 1 x 74LS32 (4 OR): dùng 1 cổng OR để cộng hai tích.

**Tổng: 1 x 74LS04, 1 x 74LS08, 1 x 74LS32.**

Bảng chân lý (z là LSB):

| x | y | z | f |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 |
| 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 |

f = Σm(2,3,7) (z là LSB).
