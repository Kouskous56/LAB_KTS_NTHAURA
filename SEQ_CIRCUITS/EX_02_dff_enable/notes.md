# EX_02 ? D Flip-Flop with enable

## Kh?i ni?m
D-FF v?i enable: ch? capture D khi en=1. N?u en=0, gi? gi? tr? hi?n t?i.

## Truth table

| rst | en | clk | d | q (next) |
|---|---|---|---|---|
| 1 | X | X | X | 0 (reset) |
| 0 | 0 | ? | X | gi? q |
| 0 | 1 | ? | 0 | 0 |
| 0 | 1 | ? | 1 | 1 |

## ?ng d?ng
- Register v?i clock enable (ti?t ki?m power).
- IC 74LS377 (octal D register with clock enable).
