# Cau 12: f(x,y,z) = Sigma(2,3,5,7) dung 74LS138

**Phan tich:**
f = m2 + m3 + m5 + m7

**Dung 74LS138 (3-to-8 decoder, output active LOW):**
- Noi A0 = x, A1 = y, A2 = z.
- Enable: E0 = 1, E1bar = 0, E2bar = 0.
- Output Q2bar, Q3bar, Q5bar, Q7bar se o muc 0 khi minterm tuong ung duoc chon.
- F = NOT( Q2bar AND Q3bar AND Q5bar AND Q7bar ) (dung cong NAND 4 dau vao,
  hoac ket hop nhieu cong NAND 2 dau vao).

**IC can dung:** 1 x 74LS138 + 1 x 74LS00 (NAND) hoac 74LS20 (NAND 4 dau vao).
