# EXP_2 — Integrated Manual/Automatic Traffic Light

## Mục tiêu
Cài đặt hệ thống đèn giao thông tích hợp chế độ thủ công và tự động.

## Đặc tả
- SW[1]=0: manual mode (SW[0] chọn hướng).
- SW[1]=1: auto mode (bỏ qua SW[0], chạy chu kỳ 5/2/5/2 giây).
- Khi đổi mode, reset timer và đưa state đến hướng manual được chọn hoặc NS_GREEN của auto.

## Chu kỳ Auto
NS_GREEN 5s → NS_YELLOW 2s → EW_GREEN 5s → EW_YELLOW 2s → NS_GREEN ...

## Pin (Nexys A7)
- CLK100MHZ, BTNC (reset), SW[0]=direction, SW[1]=mode.
- JA1=NS_G, JA2=NS_Y, JA3=NS_R, JA4=EW_G, JA7=EW_Y, JA8=EW_R.
- CA..CG=segments, AN[0]=digit 0, AN[1]=digit 1.
