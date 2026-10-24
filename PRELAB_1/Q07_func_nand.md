# Câu 7: f = x̄y + yz dùng NAND 2 đầu vào

**Biến đổi:**
f = x̄y + yz = NOT( NOT(x̄y) AND NOT(yz) )

**Mạch NAND (4 cổng NAND2):**
- n1 = x NAND x = x̄ (NAND làm inverter)
- n2 = NAND(n1, y) = NOT(x̄y)
- n3 = NAND(y, z) = NOT(yz)
- f = NAND(n2, n3) = x̄y + yz

**Cần 4 cổng NAND 2 đầu vào -> 1 x 74LS00** (mỗi IC có 4 cổng).

**Ghi chú:** Không quên nối chân 14 (VCC) và chân 7 (GND).
