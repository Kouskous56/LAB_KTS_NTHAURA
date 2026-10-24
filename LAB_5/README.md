# LAB 5 — Lab 5: Circuit Implementation on Breadboard and Communication with FPGA

Nguồn: manual "Lab 5", phần B. LAB MANUAL (PDF pp. 97-99).

Nội dung: đèn giao thông thủ công và tích hợp auto/manual trên FPGA,
kết nối Pmod JA với 6 LED, multiplex 7 đoạn 2 digit.

## Prelab
Câu trả lời Prelab 5 nằm trong `PRELAB_5/` (PREP1-PREP5).

## Danh sách bài

| Bài | Nội dung | File chính | Kết quả tb |
|---|---|---|---|
| EXP_1 | Đèn giao thông thủ công | traffic_fsm_manual.sv, seg7_scan.sv, clock_divider_core.sv | ALL TESTS PASS |
| EXP_2 | Tích hợp manual/auto | traffic_fsm_integrated.sv, seg7_scan.sv, clock_divider_core.sv | ALL TESTS PASS |

## Pin assignment (Nexys A7-100T)
- CLK100MHZ, BTNC (reset), SW[0]=direction, SW[1]=mode.
- JA1=NS_G, JA2=NS_Y, JA3=NS_R, JA4=EW_G, JA7=EW_Y, JA8=EW_R.
- CA..CG=segments, AN[0]=digit 0, AN[1]=digit 1.

## Chay testbench
    cd LAB_5\EXP_1_manual_traffic
    iverilog -g2012 -o tb.vvp *.sv
    vvp tb.vvp

## Ghi chu
- Chia clock: DIVISOR = 50,000,000 (1 Hz). Mô phỏng dùng DIVISOR nhỏ.
- Pmod JA: 6 LED (2 đỏ, 2 vàng, 2 xanh) với điện trở 330 Ω.
- 7-segment: multiplex 2 digit, active-low, gfedcba order.
- Manual warning: pha vàng "3 seconds" nhưng timer minh họa 3,2,1,0.
