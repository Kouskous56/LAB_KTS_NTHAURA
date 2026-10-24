# EX_14 — Bộ Đếm Nhị Phân 0 đến 42 Dùng IC 74393

## Khái niệm
Thiết kế bộ đếm nhị phân đếm từ 0 đến 42 sử dụng IC 74393 (dual 4-bit binary counter) và các cổng logic.

## IC 74393
- Gồm 2 bộ đếm lên 4 bit độc lập.
- Mỗi bộ đếm có: CLK (clock), CLR (clear, active high), QA, QB, QC, QD (outputs, QA là MSB).
- Tổng 8 bit output (2 × 4 bit).

## Thiết kế

### Số bit cần thiết
- 42 = 101010₂ (6 bit).
- Cần 6 bit đếm: Q5 Q4 Q3 Q2 Q1 Q0.
- Dùng Counter 1 (4-bit): Q3 Q2 Q1 Q0 (hạ 4 bit).
- Dùng Counter 2 (4-bit): Q5 Q4 (thượng 2 bit, chỉ dùng 2 bit).

### Điều kiện reset
- Khi count = 42 (101010): Q5=1, Q4=0, Q3=1, Q2=0, Q1=1, Q0=0.
- Reset condition = Q5 AND (NOT Q4) AND Q3 AND (NOT Q2) AND Q1 AND (NOT Q0).
- Khi reset_cond = 1 → CLR = 1 → counter reset về 0.

### Sơ đồ logic
```
        ┌─────────────┐
        │  74393     │
        │  Counter 1  │── Q3 Q2 Q1 Q0 (lower 4 bits)
        │  (4-bit)    │
        │  CLK ───────┤
        │  CLR ───────┤── reset_cond
        └─────────────┘
        ┌─────────────┐
        │  74393     │
        │  Counter 2  │── Q5 Q4 (upper 2 bits)
        │  (4-bit)    │
        │  CLK ───────┤
        │  CLR ───────┤── reset_cond
        └─────────────┘

reset_cond = Q5 · Q̄4 · Q3 · Q̄2 · Q1 · Q̄0
```

### Lưu ý
- CLR là active high (mức 1 → reset).
- Khi reset_cond = 1, CLR = 1 → counter reset về 0.
- Sau reset, reset_cond = 0 → CLR = 0 → counter đếm tiếp.
- Cần đảm bảo pulse CLR đủ ngắn để không giữ counter ở 0.

## Ứng dụng
- Bộ đếm với dãy đếm tùy ý (mod-N counter).
- Frequency divider.
- Digital clock, timer.
- Event counter.
