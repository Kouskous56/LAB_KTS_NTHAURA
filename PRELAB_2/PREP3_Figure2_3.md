# PREP 3 — Mạch Hình 2.3 (F = x + y + z)

## Mô tả mạch (Figure 2.3)

Mạch gồm các cổng logic với 3 input x, y, z và 1 output F:

- **x** → input trên cổng OR (trái) và input trên cổng NAND (trên).
- **y** → input trên cổng AND và input cổng NOT.
- **z** → input dưới cổng AND và input dưới cổng NAND (dưới).

Kết nối:
- Output AND → input dưới OR (trái).
- Output OR → input dưới NAND (trên).
- Output NOT (ư) → input trên NAND (dưới).
- Output NAND (trên) → input trên NOR (phải).
- Output NAND (dưới) → input dưới NOR (phải).
- Output NOR → F.

## Phân tích logic (theo sổ tay kỹ thuật)

Đặt A=x, B=y, C=z:
- s = x̄ + y
- v1 = NOT(s · z̄) = x·ư + z
- v2 = NOT(y · z̄) = ư + z
- F1 = XNOR(v1, v2) = v1·v2 + v̄1·v̄2 = x + y + z
- F2 = x + y + z (tối giản)

→ **F = x + y + z**.

## Bảng chân lý

| x | y | z | F |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 1 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 1 |
| 1 | 1 | 1 | 1 |

F = x + y + z (chỉ 000 cho 0).

## Bình luận / Nhận xét
- Mạch Hình 2.3 mặc dù có nhiều cổng (OR, AND, NOT, NAND×2, NOR) nhưng rút gọn chỉ là F = x + y + z.
- Đây là ví dụ tốt về tối giản mạch logic.
