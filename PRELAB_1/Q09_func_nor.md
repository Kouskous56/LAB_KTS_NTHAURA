# Cau 9: f = m1 + m3 + m6 dung NOR 2 dau vao

**Tu cau 8:** F = xbar.z + x.y.zbar

**Bien doi sang dang NOR:**
F = NOT( NOT(xbar.z) AND NOT(x.y.zbar) )
  = NOT( (x + zbar) NOR? ... )

**Phuong phap NOR-NOR (POS):**
F = xbar.z + x.y.zbar
F' = NOT(F) = (x + zbar) . (xbar + ybar + z)
F = NOT(F') = NOT( (x+zbar) . (xbar+ybar+z) )

Dung NOR de tao cac tong:
- xbar = x NOR x (inverter)
- zbar = z NOR z (inverter)
- (x + zbar) = x NOR zbar (sau khi dao)
- (xbar + ybar + z) = xbar NOR ybar NOR z (sau khi dao)
- F = NOR( (x+zbar)bar, (xbar+ybar+z)bar )

**So luong IC:** Can 2-3 x 74LS02 (4 cong NOR moi IC) + co the 74LS04 (inverter).
Hinh ve san: DIP switch, 3 IC 74HC02 (NOR) - sinh vien dien so chan va noi day.
