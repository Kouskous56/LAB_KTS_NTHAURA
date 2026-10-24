# EX_21 — Hệ Tuần Tự PLA + T-FF (Câu 7)

## Khái niệm
Hệ tuần tự có 1 ngõ vào X, 2 ngõ ra Z1 (Moore) và Z2 (Mealy). Chuyển trạng thái ở cạnh xuống clock.

## Giản đồ trạng thái

### Trạng thái và ngõ ra Moore (Z1)
| Trạng thái | Z1 (Moore) |
|------------|------------|
| S0         | 1          |
| S1         | 0          |
| S2         | 1          |
| S3         | 0          |

### Bảng chuyển trạng thái

| Trạng thái hiện tại | X=0 (trạng thái tiếp theo, Z2) | X=1 (trạng thái tiếp theo, Z2) |
|---------------------|-------------------------------|-------------------------------|
| S0                  | S3, Z2=1                      | S1, Z2=1                      |
| S1                  | S1, Z2=0                      | S0, Z2=1                      |
| S2                  | S3, Z2=1                      | S1, Z2=0                      |
| S3                  | S0, Z2=1                      | S1, Z2=1                      |

*Lưu ý: Trong đề gốc, S3 có 2 đường đi với X=0 (S0 và S2). Đây có thể là lỗi in ấn. Implementation sử dụng S3: X=0 → S0.*

## Gán trạng thái
QAQB: S0=10, S1=11, S2=00, S3=01.

## Thiết kế bằng PLA và T-FF

### T-FF
Q_next = T XOR Q, nên T = Q_next XOR Q.

### Phương trình PLA

**T_A** (cho QA):
T_A = (NOT QA AND (QB OR X)) OR (QA AND NOT QB AND NOT X)

**T_B** (cho QB):
T_B = NOT QB OR (NOT QA AND QB AND NOT X) OR (QA AND QB AND X)

**Z1** (Moore): Z1 = NOT QB

**Z2** (Mealy): Z2 = (NOT QA AND NOT X) OR (NOT QA AND QB) OR (QA AND NOT QB) OR (QA AND QB AND X)

### Bảng chân lý tổng hợp

| QA | QB | X | Trạng thái | T_A | T_B | Z1 | Z2 |
|----|----|---|------------|-----|-----|----|----|
| 0  | 0  | 0 | S2         | 0   | 1   | 1  | 1  |
| 0  | 0  | 1 | S2         | 1   | 1   | 1  | 0  |
| 0  | 1  | 0 | S3         | 1   | 1   | 0  | 1  |
| 0  | 1  | 1 | S3         | 1   | 0   | 0  | 1  |
| 1  | 0  | 0 | S0         | 1   | 1   | 1  | 1  |
| 1  | 0  | 1 | S0         | 0   | 1   | 1  | 1  |
| 1  | 1  | 0 | S1         | 0   | 0   | 0  | 0  |
| 1  | 1  | 1 | S1         | 0   | 1   | 0  | 1  |

## Ứng dụng
- Sequential system design with PLA.
- T-FF based state machine.
- Moore + Mealy mixed output.
- PLA programming.
