# EX_07 — Demultiplexer 1-to-8

## Khái niệm
DEMUX 1-to-8 định tuyến dữ liệu đầu vào (d) đến một trong tám đầu ra (y[0..7])
dựa trên 3 bit chọn (sel[2:0]).

## Code SystemVerilog
```systemverilog
module demux1to8 (input logic d, input logic [2:0] sel, output logic [7:0] y);
    always_comb begin
        y = 8'b0;
        y[sel] = d;
    end
endmodule
```

## Ứng dụng
- Định tuyến dữ liệu đến 8 đích.
- Giải mã địa chỉ (address decoding).
- IC 74LS138 là decoder 3-to-8 (DEMUX với d=1, active-low outputs).
