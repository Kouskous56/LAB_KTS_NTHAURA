# EXP_3 — D Flip-Flop 74LS74

## Function table (74LS74)
- /PRE=/CLR=1: chốt D ở cạnh lên clock.
- /PRE=0: set Q=1 (bất đồng bộ).
- /CLR=0: clear Q=0 (bất đồng bộ).
- /PRE=/CLR=0: trạng thái cấm (không dùng).

## IC
- 1 x 74LS74 (dual D-FF, cạnh lên, preset/clear active-low).

## Truth table (Table 3.5)
PRE CLR CLK D | Q Qbar
1   1   ↑   0 | 0 1
1   1   ↑   1 | 1 0
1   1   ↓   X | giữ Q
0   1   X   X | 1 0  (set)
1   0   X   X | 0 1  (clear)

## Pin (Nexys A7)
- SW[0]=D, SW[1]=PRE, SW[2]=CLR, LED[0]=Q, LED[1]=Qbar.
- CLK từ clock onboard hoặc switch.

## Bình luận
- Testbench kiểm tra preset, clear, capture D=0/1, complement output.
- RTL Viewer sau synthesis có thể tối giản khác sơ đồ cổng.
