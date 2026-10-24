# PRELAB 2 — Bài 2 phần chuẩn bị

Nguồn: manual "Lab 2", phần A. PRELAB (PDF pp. 21-28).

Nội dung: viết code SystemVerilog mô tả mạch logic (Hình 2.3), IC multiplexer 74LS151
(triển khai f = Σ(1,2,4,7)), và IC decoder 74LS138 (triển khai f = Σ(0,2,5,7)).

## Danh sách

| File | Nội dung |
|---|---|
| [PREP1_SOP.md](PREP1_SOP.md) | Prep 1: hàm SOP, f = z + xy |
| [PREP2_Kmap.md](PREP2_Kmap.md) | Prep 2: hàm theo Table 2.1, K-map |
| [PREP3_Figure2_3.md](PREP3_Figure2_3.md) | Prep 3: mạch Hình 2.3, F = x·ȳ |
| [PREP4_mux_74LS151.md](PREP4_mux_74LS151.md) | Prep 4: 74LS151, f = Σ(1,2,4,7) |
| [PREP5_decoder_74LS138.md](PREP5_decoder_74LS138.md) | Prep 5: 74LS138, f = Σ(0,2,5,7) |

## Pin assignment chuẩn (Nexys A7-100T)
- SW[2]=x, SW[1]=y, SW[0]=z; LED[2:0] hiển thị input; LED[15]=f.

## Lưu ý
- Prelab Q12 dùng f = Σ(0,3,4,7). Lab manual Experiment 5 ghi f = Σ(2,3,5,7).
- Hai biểu thức không tương đương. Xác nhận với giảng viên trước khi lắp mạch.
