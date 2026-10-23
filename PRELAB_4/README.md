# PRELAB 4 - Lab 4: Implementation of combinational and sequential circuits on FPGA

Nguon: manual "Lab 4", phan A. PRELAB (PDF pp. 64-71).

Moi bai co: module thiet ke + testbench (iverilog + vvp) + top_module cho Nexys A7 + XDC.
Da kiem iverilog: 5/5 PASS.

| Bai | Noi dung | File chinh | Ket qua tb |
|---|---|---|---|
| EXP_4_1 | Full Adder (Fig. 4.1) | FA_ex1.sv | ALL TESTS PASS |
| EXP_4_2 | 4-bit Adder/Subtractor, 2 phuong phap | addsub_4bit_m1.sv, addsub_4bit_m2.sv, FA_ex1.sv | ALL TESTS PASS (512 luot) |
| EXP_4_3 | BCD -> 7 doan anode chung (Table 4.1) | bcd7seg.sv | ALL TESTS PASS (16 to hop) |
| EXP_4_4 | Bo chia clock 100 MHz -> 1 Hz | clock_divider_core.sv | ALL TESTS PASS |
| EXP_4_5 | May trang thai 4 trang thai | fsm_4state_core.sv | ALL TESTS PASS (8 chuyen trang thai) |

## Pin assignment (Nexys A7-100T)

- EXP_4_1: SW[2]=A, SW[1]=B, SW[0]=Ci, LED[0]=S, LED[15]=Co.
- EXP_4_2: SW[3:0]=A, SW[7:4]=B, SW[8]=sel, LED[3:0]=S, LED[4]=Co.
- EXP_4_3: SW[3:0]=I (BCD), CA..CG=segments ({g..a}), AN[0]=0 (digit phai nhat).
- EXP_4_4: CLK100MHZ -> clk, BTNC -> reset (muc cao), LED[0]=clk/1Hz.
- EXP_4_5: CLK100MHZ, BTNC (reset), SW[0]=x_in, LED[1:0]=y_out.

## Chay testbench

    cd PRELAB_4\EXP_4_1
    iverilog -g2012 -o tb.vvp *.sv
    vvp tb.vvp

## Ghi chu

- Bo chia clock: DIVISOR = 50000000 mac dinh; khi mo phong doi con 4 (da lam trong tb), phai tra lai 50000000 truoc khi nap bo.
- 7 doan: common anode, 0 = segment sang. Table 4.1 chi dien san hang 0000 (1000000), cac hang con lai dien theo chuan hex A-F.
- FSM: ma hoa S0=00, S1=01, S2=10, S3=11; chuyen trang thai theo code trong manual.
- File create_project.tcl trong moi thu muc tao project Vivado (part xc7a100tcsg324-1) voi sources + XDC; sau do mo GUI va Generate Bitstream.
