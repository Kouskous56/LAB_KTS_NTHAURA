# EX_05 — Demultiplexer 1-to-2 (cơ bản)

## Khái niệm
DEMUX 1-to-2 định tuyến dữ liệu đầu vào (d) đến một trong hai đầu ra (y0, y1)
dựa trên tín hiệu chọn (sel).
- sel=0 → y0 = d, y1 = 0
- sel=1 → y0 = 0, y1 = d

## Truth table

| sel | d | y0 | y1 |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 0 | 0 |
| 1 | 1 | 0 | 1 |

## Code SystemVerilog
```systemverilog
module demux1to2 (input logic d, sel, output logic y0, y1);
    assign y0 = (sel == 1'b0) ? d : 1'b0;
    assign y1 = (sel == 1'b1) ? d : 1'b0;
endmodule
```

## Ứng dụng
- Định tuyến dữ liệu đến nhiều đích.
- Giải mã địa chỉ (address decoding).
- Xây dựng DEMUX lớn hơn từ DEMUX nhỏ.
