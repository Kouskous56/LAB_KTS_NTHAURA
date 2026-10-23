# LAB_KTS_NTHAURA

Bài lab môn Kỹ thuật số (KTS) — thiết kế mạch tổ hợp và mạch tuần tự, kiểm chứng bằng
**iverilog**, **Logisim Evolution** và **SPICE** (LTspice + ngspice).

| Thư mục | Nội dung | Số bài |
|---|---|---|
| [`LAB_2/`](LAB_2/README.md) | Boolean algebra và mạch tổ hợp | 5 |
| [`PRELAB_3/`](PRELAB_3/README.md) | Bài 3 phần chuẩn bị | 4 |
| [`LAB_3/`](LAB_3/README.md) | Mạch tổ hợp và mạch tuần tự | 5 |
| [`PRELAB_4/`](PRELAB_4/README.md) | Bài 4 phần chuẩn bị (FPGA) | 5 |
| [`LAB_4/`](LAB_4/README.md) | Mạch tổ hợp và tuần tự trên FPGA | 6 |
| [`REPORT_EVIDENCE.md`](REPORT_EVIDENCE.md) | Bảng tổng hợp minh chứng của 14 bài | — |
| [`LAB_3/IC_REFERENCE.md`](LAB_3/IC_REFERENCE.md) | Chức năng và pinout IC (74LS74, 74LS283, 74LS86, 74LS08, 74LS32, 74LS151, 74LS138) | — |

## Kết quả kiểm chứng

| Công cụ | Kết quả |
|---|---|
| iverilog (testbench) | **25/25** project PASS (LAB_2 5, PRELAB_3 4, LAB_3 5, PRELAB_4 5, LAB_4 6) |
| Logisim Evolution 5.0.0 | **14/14** project khớp (chỉ các bài chương 2-3 có sơ đồ Logisim) |
| SPICE (LTspice 26.1.1 + ngspice 46) | **14/14** project PASS (chỉ các bài chương 2-3 có netlist SPICE) |
| Vivado bitstream | 5/5 file `.bit` của `LAB_2`; chương 3-4 chưa build `.bit` (người dùng tự build) |

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
