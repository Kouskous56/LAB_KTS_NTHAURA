# PRELAB 4 — Bài 4 phần chuẩn bị (FPGA)

Nguồn: manual "Lab 4", phần A. PRELAB (PDF pp. 64-71).

Nội dung: Full Adder, Adder/Subtractor 4 bit, BCD→7 đoạn, bộ chia clock
100 MHz→1 Hz, và FSM 4 trạng thái.

## Danh sách

| File | Nội dung |
|---|---|
| [PREP1_full_adder.md](PREP1_full_adder.md) | Prep 1: Full Adder, S=A⊕B⊕Ci, Co=AB+ACi+BCi |
| [PREP2_addsub_4bit.md](PREP2_addsub_4bit.md) | Prep 2: Adder/Subtractor 4 bit (2 phương pháp) |
| [PREP3_bcd7seg.md](PREP3_bcd7seg.md) | Prep 3: BCD→7 đoạn anode chung (Table 4.1) |
| [PREP4_clock_divider.md](PREP4_clock_divider.md) | Prep 4: Bộ chia clock 100 MHz→1 Hz |
| [PREP5_fsm.md](PREP5_fsm.md) | Prep 5: FSM 4 trạng thái (S0=00,S1=01,S2=10,S3=11) |

## Pin assignment (Nexys A7-100T)

- EXP_4_1: `SW[2]=A, SW[1]=B, SW[0]=Ci, LED[0]=S, LED[15]=Co`.
- EXP_4_2: `SW[3:0]=A, SW[7:4]=B, SW[8]=sel, LED[3:0]=S, LED[4]=Co`.
- EXP_4_3: `SW[3:0]=I (BCD), CA..CG=segments ({g..a}), AN[0]=0 (digit phải nhất)`.
- EXP_4_4: `CLK100MHZ -> clk, BTNC -> reset (mức cao), LED[0]=clk/1Hz`.
- EXP_4_5: `CLK100MHZ, BTNC (reset), SW[0]=x_in, LED[1:0]=y_out`.

## Lưu ý
- Bộ chia clock: `DIVISOR = 50000000` mặc định; khi mô phỏng đổi còn `4`, **phải trả lại 50000000** trước khi nạp bo.
- 7 đoạn: common anode, `0 = segment sáng`. Table 4.1 chỉ điền sẵn hàng 0000 (`1000000`), các hàng còn lại điền theo chuẩn hex A–F.
- FSM: mã hóa `S0=00, S1=01, S2=10, S3=11`; chuyển trạng thái theo code trong manual.
- File `create_project.tcl` trong mỗi thư mục tạo project Vivado (part xc7a100tcsg324-1) với sources + XDC.
