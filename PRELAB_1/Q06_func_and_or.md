# Cau 6: f(x,y,z) = xbar.y + y.z (AND-OR)

**Ham:** f = NOT(x) AND y OR y AND z = y . (xbar + z)

**IC can dung:**
- 1 x 74LS04 (6 NOT): dung 1 cong NOT de tao xbar.
- 1 x 74LS08 (4 AND): dung 2 cong AND de tao xbar.y va y.z.
- 1 x 74LS32 (4 OR): dung 1 cong OR de cong hai tich.

**Tong: 1 x 74LS04, 1 x 74LS08, 1 x 74LS32.**

Bang chan ly (z la LSB):

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

f = Sigma(2,3,7) (z la LSB).
