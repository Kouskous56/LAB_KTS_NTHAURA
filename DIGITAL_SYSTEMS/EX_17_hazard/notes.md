# EX_17 — Static-1 Hazard (Câu 3)

## Khái niệm
Hazard (xung nhọn/glitch) xảy ra trong mạch tổ hợp khi có sự trễ khác nhau giữa các đường tín hiệu, gây ra output không mong muốn trong thời gian ngắn.

## Mạch gốc

### Sơ đồ
```
        ┌──────┐
X1 ────┤      │
       │ NAND ├──── Y1 = NOT(X1·X2) ──┐
X2 ────┤      │                       │
        └──────┘                       │
                                       ├── NAND ── Z = NOT(Y1·Y2)
        ┌──────┐                       │
X2 ────┤ NOT  ├──── X2_bar ──┐        │
        └──────┘            │        │
                            │        │
        ┌──────┐            │        │
X3 ────┤      │            │        │
       │ NAND ├──── Y2 = NOT(X3·X2_bar) ─┘
X2_bar─┤      │
        └──────┘
```

### Hàm logic
Z = NOT(Y1 · Y2) = NOT(NOT(X1·X2) · NOT(X3·X̄2)) = X1·X2 + X3·X̄2

### Phân tích timing (X1=1, X3=1, X2: 1→0)
- Gate delay = 10ns mỗi cổng.
- Trước transition: X2=1, X2_bar=0, Y1=0, Y2=1, Z=1
- t=0: X2 chuyển 1→0
- t=10ns: X2_bar chuyển 0→1, Y1 chuyển 0→1
- t=10-20ns: Y1=1, Y2=1 (chưa cập nhật) → Z = NOT(1·1) = **0** ← GLITCH!
- t=20ns: Y2 chuyển 1→0
- t>20ns: Y1=1, Y2=0 → Z = NOT(1·0) = 1

**→ Static-1 hazard:** Z nên luôn =1 nhưng tạm thời xuống 0.

## Loại hazard
**Static-1 hazard**: Output nên giữ mức 1 nhưng tạm thời xuống 0 do sự trễ giữa các đường.

## Khắc phục

### Nguyên lý
Thêm term consensus (term bao phủ) để loại bỏ hazard:
- Z = X1·X2 + X3·X̄2 + **X1·X3** (consensus term)
- Khi X2 chuyển 1→0, term X1·X3 = 1·1 = 1 luôn active, giữ Z=1.

### Mạch khắc phục
```
        ┌──────┐
X1 ────┤      │
       │ NAND ├──── Y1 = NOT(X1·X2) ──┐
X2 ────┤      │                       │
        └──────┘                       │
                                       ├── NAND ── t = NOT(Y1·Y2) ──┐
        ┌──────┐                       │                             │
X3 ────┤      │                       │                             │
       │ NAND ├──── Y2 = NOT(X3·X̄2) ─┘                             │
X2_bar─┤      │                                                     │
        └──────┘                                                     │
                                                                    │
        ┌──────┐                                                     │
X1 ────┤      │                                                     │
       │ NAND ├──── Y3 = NOT(X1·X3) ──┐                             │
X3 ────┤      │                       │                             │
        └──────┘                       │                             │
                                       ├── NAND ── t_bar = NOT(t) ──┤
        ┌──────┐                       │                             │
t ─────┤      │                       │                             │
       │ NAND ├──── t_bar ────────────┘                             │
t ─────┤      │                                                     │
        └──────┘                                                     │
                                                                    │
        ┌──────┐                                                     │
t_bar ──┤      │                                                     │
       │ NAND ├──── Z = NOT(t_bar·Y3) ───────────────────────────────┘
Y3 ────┤      │
        └──────┘
```

Z_fixed = NOT(t_bar · Y3) = NOT(NOT(t) · NOT(X1·X3)) = t + X1·X3
= (X1·X2 + X3·X̄2) + X1·X3 = X1·X2 + X3·X̄2 + X1·X3 ✓

## Ứng dụng
- Hazard analysis trong mạch tổ hợp.
- Timing analysis và glitch detection.
- Thiết kế mạch robust (không có glitch).
- Digital circuit optimization.
