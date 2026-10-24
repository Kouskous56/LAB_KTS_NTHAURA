# EXP_5 — Máy trạng thái 4 trạng thái (Figure 3.6)

## State assignment
A=00, B=01, C=10, D=11.

## Chuyển trạng thái
| Trạng thái hiện tại | S1S0 | X=0 → kế | X=1 → kế |
|---|:---:|---|---|
| A | 00 | A (00) | B (01) |
| B | 01 | A (00) | D (11) |
| C | 10 | A (00) | B (01) |
| D | 11 | A (00) | C (10) |

## Phương trình next-state
D1 = S1+ = X·S0
N  = (S1·S0)̄
D0 = S0+ = X·N = X·(S1·S0)̄

## IC
- 1 x 74LS74 (2 FF), 1 x 74LS00 (NAND tạo N), 1 x 74LS08 (2 AND).

## Pin (Nexys A7)
- SW[0]=X (input), SW[1]=reset (active low).
- LED[1:0] = S1S0 (trạng thái), LED[15]=output (nếu có).

## Trace quy định
Reset về A, sau đó X = 0,1,1,0,0,0,1:
A → A → B → D → A → A → A → B
S1S0: 00, 00, 01, 11, 00, 00, 00, 01.

## Bình luận
- Testbench kiểm tra trace chuẩn.
- RTL Viewer sau synthesis có thể tối giản khác sơ đồ cổng.
