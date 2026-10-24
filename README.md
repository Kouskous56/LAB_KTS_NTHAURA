# LAB_KTS_NTHAURA

Bài lab môn Kỹ thuật số (KTS) — thiết kế mạch tổ hợp và mạch tuần tự, kiểm chứng bằng
**iverilog**, **Logisim Evolution** và **SPICE** (LTspice + ngspice).

| Thư mục | Nội dung | Số bài |
|---|---|---|
  | [`PRELAB_1/`](PRELAB_1/README.md) | Bài 1 phần chuẩn bị (breadboard, IC pinout) | 12 |
  | [`PRELAB_2/`](PRELAB_2/README.md) | Bài 2 phần chuẩn bị (MUX, decoder, Boolean) | 3 |
  | [`LAB_1/`](LAB_1/README.md) | Mạch tổ hợp trên breadboard (Boolean function) | 5 |
| [`LAB_2/`](LAB_2/README.md) | Boolean algebra và mạch tổ hợp | 5 |
| [`PRELAB_3/`](PRELAB_3/README.md) | Bài 3 phần chuẩn bị | 4 |
| [`LAB_3/`](LAB_3/README.md) | Mạch tổ hợp và mạch tuần tự | 5 |
| [`PRELAB_4/`](PRELAB_4/README.md) | Bài 4 phần chuẩn bị (FPGA) | 5 |
| [`LAB_4/`](LAB_4/README.md) | Mạch tổ hợp và tuần tự trên FPGA | 6 |
| [PRELAB_5/](PRELAB_5/README.md) | Bài 5 phần chuẩn bị (traffic light, FPGA) | 5 |
| [LAB_5/](LAB_5/README.md) | Đèn giao thông và giao tiếp FPGA-breadboard | 2 |
| [`IC_SV/`](IC_SV/README.md) | Thư viện submodule SystemVerilog cho 52 IC logic phổ biến | 52 |
| [`REPORT_EVIDENCE.md`](REPORT_EVIDENCE.md) | Bảng tổng hợp minh chứng của 14 bài | — |
| [`LAB_3/IC_REFERENCE.md`](LAB_3/IC_REFERENCE.md) | Chức năng và pinout IC (74LS74, 74LS283, 74LS86, 74LS08, 74LS32, 74LS151, 74LS138) | — |

## Kết quả kiểm chứng

| Công cụ | Kết quả |
|---|---|
| iverilog (testbench) | **32/32** project PASS (LAB_1 5, LAB_2 5, PRELAB_3 4, LAB_3 5, PRELAB_4 5, LAB_4 6, LAB_5 2) |
| Logisim Evolution 5.0.0 | **14/14** project khớp (chỉ các bài chương 2-3 có sơ đồ Logisim) |
| SPICE (LTspice 26.1.1 + ngspice 46) | **14/14** project PASS (chỉ các bài chương 2-3 có netlist SPICE) |
| Vivado bitstream | 5/5 file `.bit` của `LAB_2`; chương 3-4 chưa build `.bit` (người dùng tự build) |
| IC_SV testbench (iverilog) | **52/52** IC PASS (thư viện submodule 74xx) |

Chi tiết từng bài: [`REPORT_EVIDENCE.md`](REPORT_EVIDENCE.md).

## Cấu trúc một bài

```
LAB_3/EXP_3_dff_74ls74/
├── dff74ls74.sv              # module thiết kế (74LS74: cạnh lên, PRE/CLR mức thấp)
├── tb.sv                     # testbench, kết thúc bằng "ALL TESTS PASS"
├── top_module.sv             # nối chân với bo Nexys A7
├── Nexys-A7-100T-Master.xdc  # ràng buộc chân
├── dff74ls74.circ            # sơ đồ Logisim, dùng IC thật 74LS74 của thư viện TTL
└── dff74ls74.cir             # netlist SPICE của cùng mạch
```

Mỗi mạch có **hai dạng mô hình song song**: SystemVerilog để build lên FPGA, và
sơ đồ Logisim / netlist SPICE để mô phỏng và đối chiếu kết quả.

## Chạy testbench

```powershell
cd LAB_3\EXP_3_dff_74ls74
iverilog -g2012 -o tb.vvp *.sv
vvp tb.vvp
```

## Phạm vi repo

Repo mang **mã thiết kế và tài liệu**: mô hình SystemVerilog, ràng buộc chân, project
Vivado kèm bitstream, sơ đồ Logisim (`.circ`), netlist SPICE (`.cir`) và các file
ghi chú (`.md`).

Các **script công cụ** (`tools/*.py`), **ảnh sinh tự động** (`*.png`) và **bảng kết quả
thô** (`logisim_table.txt`, `spice_table_*.txt`, `logisim_vectors.txt`) được giữ ở máy
cá nhân của tác giả, **không đưa lên repo**; chúng sinh lại được từ mã thiết kế và
netlist có sẵn trong repo.
