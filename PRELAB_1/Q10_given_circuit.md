# Cau 10: Phan tich mach cho san, toi gian F2

**Mach (Figure):**
- A -> NOT -> input tren cua OR
- B -> input duoi cua OR; B cung re nhanh xuong NAND duoi
- C -> NOT -> tao Cbar; Cbar di den input duoi cua NAND tren (nhanh re len) va den input tren cua NAND duoi
- Output OR -> input tren cua NAND tren
- Output NAND tren va NAND duoi -> XNOR -> F

**Phan tich:**
- OR output: X = Abar + B
- NAND tren: Y = NOT( X . Cbar ) = NOT( (Abar+B) . Cbar )
- NAND duoi: Z = NOT( B . Cbar )
- F = Y XNOR Z = NOT(Y XOR Z)

**Tinh Y, Z:**
Y = NOT( (Abar+B) . Cbar ) = C + NOT(Abar+B) = C + A . Bbar
Z = NOT( B . Cbar ) = Bbar + C

**Tinh F = Y XNOR Z:**
Dat P = C + A.Bbar, Q = Bbar + C.
- B=0: P = C, Q = 1 -> F = C
- B=1: P = C + A, Q = C -> F = (C+A) XNOR C
  - C=0: F = A XNOR 0 = Abar
  - C=1: F = 1 XNOR 1 = 1

Tong hop: F = Bbar.C + B.(Abar.Cbar + C) = Bbar.C + Abar.B.Cbar + B.C
          = C(Bbar+B) + Abar.B.Cbar = C + Abar.B.Cbar

Rut gon (dung C + Abar.B.Cbar = C + Abar.B):
**F = Abar.B + C**

**SOP form:** F = Abar.B + C (hoac viet day du: F = Abar.B.C + Abar.B.Cbar + A.B.C + A.Bbar.C + Abar.Bbar.C).

**F2 (toi gian):** F2 = xbar.y + z (voi x=A, y=B, z=C).

**Nhan xet:** F1 va F2 phai cho cung ket qua logic vi F2 la dang toi gian cua F1.
