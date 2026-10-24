# EX_03 — JK Flip-Flop

## Khái niệm
JK Flip-Flop là phiên bản cải tiến của SR latch/flip-flop.
- J=0,K=0: giữ (hold)
- J=0,K=1: reset (Q=0)
- J=1,K=0: set (Q=1)
- J=1,K=1: toggle (Q=~Q)

Không có trạng thái cấm (invalid state) như SR latch.

## Ứng dụng
- IC 74LS76 (dual JK-FF with preset/clear).
- IC 74LS107 (dual JK-FF with clear).
- Counter, frequency divider, toggle circuit.
