# EX_02 — Multiplexer 4-to-1

## Khái niệm
MUX 4-to-1 chọn một trong bốn đầu vào dữ liệu (d[0..3]) theo 2 bit chọn (sel[1:0]).

## Code SystemVerilog
```systemverilog
module mux4to1 (input logic [3:0] d, input logic [1:0] sel, output logic y);
    assign y = d[sel];
endmodule
```

## Ứng dụng
- Chọn dữ liệu từ 4 nguồn.
- Xây dựng MUX 8:1 từ hai MUX 4:1.
- Implement hàm Boolean 2 biến.
