# EX_03 — Multiplexer 8-to-1

## Khái niệm
MUX 8-to-1 chọn một trong tám đầu vào dữ liệu (d[0..7]) theo 3 bit chọn (sel[2:0]).

## Code SystemVerilog
```systemverilog
module mux8to1 (input logic [7:0] d, input logic [2:0] sel, output logic y);
    assign y = d[sel];
endmodule
```

## Ứng dụng
- Chọn dữ liệu từ 8 nguồn.
- Implement hàm Boolean 3 biến (MUX as function generator).
- IC 74LS151 là MUX 8-to-1 với enable active-low.
