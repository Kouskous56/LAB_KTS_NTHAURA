# EX_18 — Mạch Đếm 3 Bit Dùng SR-FF (Câu 4)

## Khái niệm
Thiết kế mạch đếm nối tiếp (synchronous) 3-bit Q2Q1Q0 (Q2 là MSB) với dãy đếm:
000 → 111 → 110 → 101 → 001 → 000 (Modulo 5).

Sử dụng SR-FF, xung clock cạnh xuống, Preset tích cực cao, Clear tích cực thấp.

## Gợi ý: Tương quan SR-FF với D-FF
- SR-FF: S=1,R=0 → Set (Q=1); S=0,R=1 → Reset (Q=0); S=0,R=0 → Hold.
- D-FF: Q_next = D.
- Để SR-FF hoạt động như D-FF: **S = D, R = NOT(D)**.
  - D=1 → S=1, R=0 → Set → Q=1 ✓
  - D=0 → S=0, R=1 → Reset → Q=0 ✓

## Bảng trạng thái

| Q2 | Q1 | Q0 | Q2+ | Q1+ | Q0+ |
|----|----|----|-----|-----|-----|
| 0  | 0  | 0  | 1   | 1   | 1   |
| 1  | 1  | 1  | 1   | 1   | 0   |
| 1  | 1  | 0  | 1   | 0   | 1   |
| 1  | 0  | 1  | 0   | 0   | 1   |
| 0  | 0  | 1  | 0   | 0   | 0   |

## Thiết kế D-FF
D_i = Q_i+ (bit tiếp theo).

D2 = Q̄2·Q̄1·Q̄0 + Q2·Q1·Q0 + Q2·Q1·Q̄0 = Q2·Q1 + Q̄2·Q̄1·Q̄0
D1 = Q̄2·Q̄1·Q̄0 + Q2·Q1·Q0
D0 = Q̄2·Q̄1·Q̄0 + Q2·Q1·Q̄0 + Q2·Q̄1·Q0

## Chuyển sang SR-FF
S_i = D_i, R_i = NOT(D_i) cho mỗi bit.

## SR-FF đặc tả
- Clock: cạnh xuống (negedge).
- Preset: tích cực cao (preset=1 → Q=1).
- Clear: tích cực thấp (clear_n=0 → Q=0).
- Ưu tiên: Preset > Clear > S/R.

## Ứng dụng
- Mạch đếm đồng bộ (synchronous counter).
- State machine design.
- Digital clock, timer.
- Frequency divider.
