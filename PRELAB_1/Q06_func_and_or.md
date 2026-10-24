# Cau 6: f(x,y,z) = xbar.y + ybar.z (AND-OR)

**Ham:** f = NOT(x) AND y OR NOT(y) AND z

**IC can dung:**
- 1 x 74LS04 (6 NOT): dung 2 cong NOT de tao xbar va ybar.
- 1 x 74LS08 (4 AND): dung 2 cong AND de tao xbar.y va ybar.z.
- 1 x 74LS32 (4 OR): dung 1 cong OR de cong hai tich.

**Tong: 1 x 74LS04, 1 x 74LS08, 1 x 74LS32.**

Bang chan ly:

| x | y | z | xbar | ybar | xbar.y | ybar.z | f |
|---|---|---|---|---|---|---|---|
| 0 | 0 | 0 | 1 | 1 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | 1 | 0 | 1 | 1 |
| 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 1 | 0 | 1 | 0 | 1 |
| 1 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 0 | 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 |

Wait, tinh lai: f = xbar.y + ybar.z
- 000: 1*0 + 1*0 = 0
- 001: 1*0 + 1*1 = 1
- 010: 1*1 + 0*0 = 1
- 011: 1*1 + 0*1 = 1
- 100: 0*0 + 1*0 = 0
- 101: 0*0 + 1*1 = 1
- 110: 0*1 + 0*0 = 0
- 111: 0*1 + 0*1 = 0

Bang dung:

| x | y | z | f |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 0 |

f = Sigma(1,2,3,5) (z la LSB).
