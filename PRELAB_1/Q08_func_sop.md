# Cau 8: f(x,y,z) = m1 + m3 + m6 (z la LSB) - SOP form

**Minterm (z la LSB):**
- m1: x=0,y=0,z=1 -> xbar.ybar.z
- m3: x=0,y=1,z=1 -> xbar.y.z
- m6: x=1,y=1,z=0 -> x.y.zbar

**SOP form:**
F = xbar.ybar.z + xbar.y.z + x.y.zbar

**Rut gon:**
F = xbar.z (ybar + y) + x.y.zbar = xbar.z + x.y.zbar

**IC can dung:**
- 74LS04 (NOT): tao xbar, zbar (neu can).
- 74LS08 (AND): tao xbar.z va x.y.zbar (can 2 cong AND, nhung x.y.zbar can 3 dau vao -> dung 2 cong AND).
- 74LS32 (OR): cong hai tich.

**Tong: 1 x 74LS04, 1 x 74LS08, 1 x 74LS32.**
