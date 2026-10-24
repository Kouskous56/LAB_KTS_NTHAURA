# Cau 9: f = Sigma(1,3,6) dung NOR 2 dau vao

**Tu cau 8:** f = Sigma(1,3,6) = xbar.z + x.y.zbar.

**Dang POS (tich cac tong):**
f = (x + y + z)(x + ybar + z)(xbar + y + z)(xbar + y + zbar)(xbar + ybar + zbar)

**Chuyen sang NOR:**
Moi tong (OR) co the tao bang NOR + inverter; tich cac tong tao bang NOR cua cac
tong dao. Dung 74LS02 (NOR) va 74LS04 (NOT) de hoan thanh.

**So luong IC:** Can 2-3 x 74LS02 (4 cong NOR moi IC) + 74LS04 (inverter).

**Bang chan ly (f = Sigma(1,3,6)):**
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

Luu y: Khong nham voi bieu thuc rut gon cua cau 7 (xbar.y + y.z).
