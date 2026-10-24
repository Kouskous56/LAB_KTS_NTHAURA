# PRELAB 4 — Lab 4: Implementation of combinational and sequential circuits on FPGA

Nguồn: manual "Lab 4", phần A. PRELAB (PDF pp. 64-71).

Mỗi bài có: module thiết kế + testbench (`iverilog` + `vvp`) + `top_module` cho Nexys A7 + XDC.
Đã kiểm iverilog: **5/5 PASS**.

| Bài | Nội dung | File chính | Kết quả tb |
|---|---|---|---|
| EXP_4_1 | Full Adder (Fig. 4.1) | `FA_ex1.sv` | ALL TESTS PASS |
| EXP_4_2 | 4-bit Adder/Subtractor, 2 phương pháp | `addsub_4bit_m1.sv`, `addsub_4bit_m2.sv`, `FA_ex1.sv` | ALL TESTS PASS (512 lượt) |
| EXP_4_3 | BCD → 7 đoạn anode chung (Table 4.1) | `bcd7seg.sv` | ALL TESTS PASS (16 tổ hợp) |
| EXP_4_4 | Bộ chia clock 100 MHz → 1 Hz | `clock_divider_core.sv` | ALL TESTS PASS |
| EXP_4_5 | Máy trạng thái 4 trạng thái | `fsm_4state_core.sv` | ALL TESTS PASS (8 chuyển trạng thái) |

## Pin assignment (Nexys A7-100T)

- EXP_4_1: `SW[2]=A, SW[1]=B, SW[0]=Ci, LED[0]=S, LED[15]=Co`.
- EXP_4_2: `SW[3:0]=A, SW[7:4]=B, SW[8]=sel, LED[3:0]=S, LED[4]=Co`.
- EXP_4_3: `SW[3:0]=I (BCD), CA..CG=segments ({g..a}), AN[0]=0 (digit phải nhất)`.
- EXP_4_4: `CLK100MHZ -> clk, BTNC -> reset (mức cao), LED[0]=clk/1Hz`.
- EXP_4_5: `CLK100MHZ, BTNC (reset), SW[0]=x_in, LED[1:0]=y_out`.

## Chạy testbench

    cd PRELAB_4\EXP_4_1
    iverilog -g2012 -o tb.vvp *.sv
    vvp tb.vvp

## Ghi chú

- Bộ chia clock: `DIVISOR = 50000000` mặc định; khi mô phỏng đổi còn `4` (đã làm trong tb), **phải trả lại 50000000** trước khi nạp bo.
- 7 đoạn: common anode, `0 = segment sáng`. Table 4.1 chỉ điền sẵn hàng 0000 (`1000000`), các hàng còn lại điền theo chuẩn hex A–F.
- FSM: mã hóa `S0=00, S1=01, S2=10, S3=11`; chuyển trạng thái theo code trong manual.
- File `create_project.tcl` trong mỗi thư mục tạo project Vivado (part xc7a100tcsg324-1) với sources + XDC; sau đó mở GUI và Generate Bitstream.
