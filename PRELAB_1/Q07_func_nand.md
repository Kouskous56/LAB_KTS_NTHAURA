# Cau 7: f = xbar.y + y.z dung NAND 2 dau vao

**Bien doi:**
f = xbar.y + y.z = NOT( NOT(xbar.y) AND NOT(y.z) )

**Mach NAND (4 cong NAND2):**
- n1 = x NAND x = xbar (NAND lam inverter)
- n2 = NAND(n1, y) = NOT(xbar.y)
- n3 = NAND(y, z) = NOT(y.z)
- f = NAND(n2, n3) = xbar.y + y.z

**Can 4 cong NAND 2 dau vao -> 1 x 74LS00** (moi IC co 4 cong).

**Ghi chu:** Khong quen noi chan 14 (VCC) va chan 7 (GND).
