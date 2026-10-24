# EX_12 — Thiết Kế Cổng Logic Từ NAND 2 Ngõ Vào

## Khái niệm
Thiết kế các cổng logic cơ bản (NOT, AND, OR, XOR) chỉ sử dụng cổng NAND 2 ngõ vào.

## Part a) Thiết kế từ NAND

### NOT (Phủ định)
- NOT(x) = NAND(x, x)
- Vì NAND(x,x) = NOT(x AND x) = NOT(x).

### AND (Và)
- AND(x,y) = NAND(NAND(x,y), NAND(x,y))
- NAND(x,y) = NOT(x AND y), NAND lại → x AND y.

### OR (Hoặc)
- OR(x,y) = NAND(NAND(x,x), NAND(y,y))
- NAND(x,x) = NOT(x), NAND(y,y) = NOT(y).
- NAND(NOT x, NOT y) = NOT(NOT x AND NOT y) = x OR y (De Morgan).

### XOR (Hoặc loại trừ)
- XOR(x,y) = NAND(NAND(x, NAND(x,y)), NAND(y, NAND(x,y)))
- Let n = NAND(x,y) = NOT(x AND y).
- a = NAND(x, n) = NOT(x AND n).
- b = NAND(y, n) = NOT(y AND n).
- z = NAND(a, b) = NOT(a AND b).
- Kiểm tra 4 trường hợp: 00→0, 01→1, 10→1, 11→0. ✓

## Part b) Mô tả VHDL (Structural)

Cho sẵn component NAND_2:
- Ngõ vào: u, v
- Ngõ ra: t
- t = NOT(u AND v)

Mô tả cấu trúc XOR:
1. n = NAND_2(x, y)
2. a = NAND_2(x, n)
3. b = NAND_2(y, n)
4. z = NAND_2(a, b)

## Ứng dụng
- Universal gate: NAND là cổng vạn năng (universal gate).
- Có thể xây dựng mọi mạch logic từ NAND.
- IC 7400 (quad 2-input NAND) là IC phổ biến nhất.
- Giảm số loại IC trong thiết kế.
