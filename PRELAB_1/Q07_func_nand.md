# Cau 7: f = xbar.y + ybar.z dung NAND 2 dau vao

**Bien doi:**
f = xbar.y + ybar.z = NOT( NOT(xbar.y) AND NOT(ybar.z) )

**Mach NAND:**
- Tao xbar = x NAND x (1 cong NAND lam inverter)
- Tao ybar = y NAND y (1 cong NAND lam inverter)
- A = xbar NAND y = NOT(xbar.y)
- B = ybar NAND z = NOT(ybar.z)
- f = A NAND B

**Can 5 cong NAND 2 dau vao -> 2 x 74LS00** (moi IC co 4 cong).

**Ghi chu:** Khong quen noi chan 14 (VCC) va chan 7 (GND).
