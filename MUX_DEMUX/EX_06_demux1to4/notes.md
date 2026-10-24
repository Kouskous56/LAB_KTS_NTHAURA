# EX_06 — Demultiplexer 1-to-4

## Khái niệm
DEMUX 1-to-4 định tuyến dữ liệu đầu vào (d) đến một trong bốn đầu ra (y[0..3])
dựa trên 2 bit chọn (sel[1:0]).

## Code SystemVerilog
```systemverilog
module demux1to4 (input logic d, input logic [1:0] sel, output logic [3:0] y);
    always_comb begin
        y = 4'b0;
        y[sel] = d;
    end
endmodule
```

## Ứng dụng
- Định tuyến dữ liệu đến 4 đích.
- Giải mã địa chỉ (address decoding).
- IC 74LS138 là decoder 3-to-8 (DEMUX với d=1).
