# LAB 4 — Lab 4: Implementation of combinational and sequential circuits on FPGA

Nguon: manual "Lab 4", phan B. LAB MANUAL (PDF pp. 72-88).

Moi bai co: module thiet ke + testbench (iverilog + vvp) + top_module cho Nexys A7 + XDC.
Da kiem iverilog: 6/6 PASS.

| Bai | Noi dung | File chinh | Ket qua tb |
|---|---|---|---|
| EXP_1 | Gia tri tuyet doi so 4 bit | absval_4bit.sv | ALL TESTS PASS |
| EXP_2 | ALU 4 bit (cong, tru, AND, OR) | alu_4bit.sv | ALL TESTS PASS (1024 luot) |
| EXP_3 | Bo dem xuong 3 bit ra 7 doan anode chung | down_counter_3bit.sv, bcd7seg.sv, clock_divider_core.sv | ALL TESTS PASS |
| EXP_4 | Bo dem len 5 -> 14 | up_counter_5to14.sv, clock_divider_core.sv | ALL TESTS PASS |
| EXP_5 | Mach tuan tu: Z=1 khi so bit 1 chia het cho 3 va so bit 0 chan (>0) | seq_det_3.sv | ALL TESTS PASS |
| EXP_6 | May tu dong ban hang (RED x3 -> FOOD, BLUE x2 -> WATER) | vending_fsm.sv | ALL TESTS PASS |

## Pin assignment (Nexys A7-100T)

- EXP_1: SW[3:0]=A, LED[3:0]=S (gia tri tuyet doi).
- EXP_2: SW[3:0]=A, SW[7:4]=B, SW[9:8]=Sel, LED[3:0]=S, LED[4]=Co.
- EXP_3: CLK100MHZ, BTNC (reset), CA..CG=segments, AN[0]=0 (digit phai nhat).
- EXP_4: CLK100MHZ, SW[0]=rst (muc cao), LED[3:0]=count (5..14).
- EXP_5: CLK100MHZ, BTNC (reset), SW[0]=x, LED[0]=z.
- EXP_6: CLK100MHZ, BTNC (reset), SW[0]=RED, SW[1]=BLUE, LED[0]=FOOD, LED[1]=WATER.

## Chay testbench

    cd LAB_4\EXP_1_absval
    iverilog -g2012 -o tb.vvp *.sv
    vvp tb.vvp

## Ghi chu

- Bo dem (EXP_3, EXP_4) dung bo chia clock 100 MHz -> 1 Hz (DIVISOR = 50000000) de thay doi moi 1 s.
- EXP_1 gia tri tuyet doi: A 4 bit two's complement, ket qua 4 bit (tran so -8 giu nguyen).
- EXP_5 la mach Moore: z cap nhat theo trang thai sau moi bit.
- File create_project.tcl trong moi thu muc tao project Vivado (part xc7a100tcsg324-1) voi sources + XDC; sau do mo GUI va Generate Bitstream.
