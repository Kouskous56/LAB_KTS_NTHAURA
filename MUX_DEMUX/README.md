# MUX_DEMUX — Bài tập Multiplexer và Demultiplexer

Thư mục này chứa 10 bài tập từ cơ bản đến nâng cao về MUX và DEMUX,
kèm code SystemVerilog, testbench và ghi chú.

## Danh sách bài tập

| Bài | Nội dung | File chính | Kết quả tb |
|---|---|---|---|
| EX_01 | MUX 2-to-1 cơ bản | `mux2to1.sv` | ALL TESTS PASS |
| EX_02 | MUX 4-to-1 | `mux4to1.sv` | ALL TESTS PASS |
| EX_03 | MUX 8-to-1 | `mux8to1.sv` | ALL TESTS PASS |
| EX_04 | MUX as Boolean function generator | `mux_function.sv` | ALL TESTS PASS |
| EX_05 | DEMUX 1-to-2 cơ bản | `demux1to2.sv` | ALL TESTS PASS |
| EX_06 | DEMUX 1-to-4 | `demux1to4.sv` | ALL TESTS PASS |
| EX_07 | DEMUX 1-to-8 | `demux1to8.sv` | ALL TESTS PASS |
| EX_08 | DEMUX as Boolean function generator | `demux_function.sv` | ALL TESTS PASS |
| EX_09 | MUX-DEMUX pair (định tuyến dữ liệu) | `mux_demux_pair.sv` | ALL TESTS PASS |
| EX_10 | Parametric N-to-1 MUX và 1-to-N DEMUX | `param_mux_demux.sv` | ALL TESTS PASS |

## Cách chạy testbench

```powershell
cd MUX_DEMUX\EX_01_mux2to1
iverilog -g2012 -o tb.vvp *.sv
vvp tb.vvp
```

## Khái niệm chính

### Multiplexer (MUX)
- Chọn một trong N đầu vào dữ liệu dựa trên tín hiệu chọn (select).
- MUX 2^k-to-1 cần k bit select.
- MUX không lưu dữ liệu (combinational).
- MUX có thể dùng để triển khai hàm Boolean (MUX as function generator).

### Demultiplexer (DEMUX)
- Định tuyến dữ liệu đầu vào đến một trong N đầu ra dựa trên tín hiệu chọn.
- DEMUX 1-to-2^k cần k bit select.
- DEMUX không lưu dữ liệu (combinational).
- DEMUX có thể dùng để triển khai hàm Boolean (DEMUX as function generator).

### So sánh MUX và DEMUX

| Đặc điểm | MUX | DEMUX |
|---|---|---|
| Số đầu vào | N (data) + k (select) | 1 (data) + k (select) |
| Số đầu ra | 1 | N |
| Chức năng | Chọn | Định tuyến |
| Implement hàm Boolean | Data inputs = giá trị hàm | Output = OR của các minterm |

## Ứng dụng
- Chọn dữ liệu (data selection).
- Định tuyến dữ liệu (data routing).
- Triển khai hàm Boolean (function generation).
- Giải mã địa chỉ (address decoding).
- Bus switching.
- Communication networks.