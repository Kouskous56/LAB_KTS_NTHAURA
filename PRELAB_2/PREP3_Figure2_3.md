# PREP 3 — Mạch Hình 2.3 (F = x · ư)

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

## Phân tích logic (theo sổ tay kỹ thuật Lab 2)

Đặt A=x, B=y, C=z. Các node từ sơ đồ:

- A = y·z
- B = (x + A)̄ = (x + yz)̄
- C = ȳ
- D = (x·C)̄ = (xȳ)̄
- F = (B + D)̄ = x·ȳ

Kết quả cuối độc lập với z, dù z có mặt ở node A/B.

→ **F = x · ȳ** (minterm m4, m5). Vector 000→111: `00001100`.

Lưu ý: sổ tay kỹ thuật (Lab 2) phân tích cho kết quả F = x·ȳ.
Đối chiếu với hình vẽ gốc và giảng viên.

## Code SystemVerilog (theo yêu cầu Prep 3)

```systemverilog
module prep3 (
    input  logic x, y, z,
    output logic f
);
    // F = x & ~y
    assign f = x & ~y;
endmodule
```

## Bảng chân lý

| x | y | z | F |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 |
| 0 | 1 | 0 | 0 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 0 | 1 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 0 |

F = x·ȳ (minterm m4, m5). Vector: 00001100.

## Bình luận / Nhận xét
- Mạch Hình 2.3 mặc dù có nhiều cổng (OR, AND, NOT, NAND×2, NOR) nhưng rút gọn chỉ là F = x·ȳ.
- Đây là ví dụ tốt về tối giản mạch logic.
