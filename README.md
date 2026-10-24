# LAB_KTS_NTHAURA

Kho lưu trữ các bài thí nghiệm và bài tập môn Kỹ thuật số (Digital Systems).

## Cấu trúc repo

Repo chỉ giữ các thư mục thí nghiệm chính (PRELAB + LAB). Các thư mục bài tập mở rộng (IC_SV, MUX_DEMUX, DEC_ENC, SEQ_CIRCUITS, FSM_LAB, DIGITAL_SYSTEMS, playground) được giữ ở local.

### PRELAB (lý thuyết & chuẩn bị)

| Thư mục | Nội dung |
|---------|----------|
| [PRELAB_1/](PRELAB_1/) | 12 file markdown Q&A |
| [PRELAB_2/](PRELAB_2/) | 5 file markdown (PREP1–PREP5) |
| [PRELAB_3/](PRELAB_3/) | 4 thí nghiệm + 4 PREP markdown |
| [PRELAB_4/](PRELAB_4/) | 5 thí nghiệm FPGA prelab + 5 PREP markdown |
| [PRELAB_5/](PRELAB_5/) | 5 file markdown (PREP1–PREP5) |

### LAB (thí nghiệm)

| Thư mục | Nội dung |
|---------|----------|
| [LAB_1/](LAB_1/) | 5 thí nghiệm Boolean (breadboard/FPGA) |
| [LAB_2/](LAB_2/) | 5 thí nghiệm (Full Adder, SOP/POS, Fig 2.4, MUX 74LS151, Decoder 74LS138) |
| [LAB_3/](LAB_3/) | 5 thí nghiệm (Full Adder, AddSub 4-bit, D-FF 74LS74, Counter 0-7, FSM) |
| [LAB_4/](LAB_4/) | 6 thí nghiệm FPGA (absval, ALU, down counter, up counter 5-14, seq det, vending) |
| [LAB_5/](LAB_5/) | 2 thí nghiệm FPGA (manual traffic, integrated auto/manual) |

## Kiểm chứng

- Tất cả testbench biên dịch với `iverilog -g2012` và in `ALL TESTS PASS`.
- Vivado synth + DRC: 0 errors.

## Cách chạy testbench

```powershell
cd LAB_1\EXP_1_1
iverilog -g2012 -o tb.vvp *.sv
vvp tb.vvp
```
