# DEC_ENC — Bài tập Decoder và Encoder

Thư mục này chứa 10 bài tập từ cơ bản đến nâng cao về Decoder và Encoder,
kèm code SystemVerilog, testbench và ghi chú.

## Danh sách bài tập

| Bài | Nội dung | File chính | Kết quả tb |
|---|---|---|---|
| EX_01 | Decoder 2-to-4 (active high) | `dec2to4.sv` | ALL TESTS PASS |
| EX_02 | Decoder 2-to-4 (active low) | `dec2to4_al.sv` | ALL TESTS PASS |
| EX_03 | Decoder 3-to-8 (như 74LS138) | `dec3to8.sv` | ALL TESTS PASS |
| EX_04 | Decoder 4-to-16 | `dec4to16.sv` | ALL TESTS PASS |
| EX_05 | Decoder as Boolean function generator | `dec_function.sv` | ALL TESTS PASS |
| EX_06 | Priority Encoder 4-to-2 | `prienc4to2.sv` | ALL TESTS PASS |
| EX_07 | Priority Encoder 8-to-3 (như 74LS148) | `prienc8to3.sv` | ALL TESTS PASS |
| EX_08 | Encoder as Boolean function generator | `enc_function.sv` | ALL TESTS PASS |
| EX_09 | Decoder-Encoder pair (round trip) | `dec_enc_pair.sv` | ALL TESTS PASS |
| EX_10 | Parametric decoder và encoder | `param_dec_enc.sv` | ALL TESTS PASS |

## Cách chạy testbench

```powershell
cd DEC_ENC\EX_01_dec2to4
iverilog -g2012 -o tb.vvp *.sv
vvp tb.vvp
```

## Khái niệm chính

### Decoder
- Biến mã nhị phân thành một trong 2^N đầu ra (one-hot).
- Decoder N-to-2^N cần N bit input.
- Output có thể active-high hoặc active-low.
- Decoder có thể dùng để triển khai hàm Boolean.

### Encoder
- Mã hóa đầu vào ưu tiên cao nhất thành mã nhị phân.
- Priority encoder: input có ưu tiên cao nhất được mã hóa.
- Output valid = 1 khi có ít nhất một input active.

### So sánh Decoder và Encoder

| Đặc điểm | Decoder | Encoder |
|---|---|---|
| Số đầu vào | N | 2^N |
| Số đầu ra | 2^N | N |
| Chức năng | Giải mã | Mã hóa |
| Implement hàm Boolean | NAND/NOR của outputs | Priority selection |

## Ứng dụng
- Giải mã địa chỉ (address decoding).
- Mã hóa ưu tiên (priority encoding).
- Interrupt controller.
- Keyboard encoder.
- Bus switching.