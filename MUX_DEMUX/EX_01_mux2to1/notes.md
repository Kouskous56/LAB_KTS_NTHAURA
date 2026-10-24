# EX_01 — Multiplexer 2-to-1 (cơ bản)

## Khái niệm
MUX 2-to-1 chọn một trong hai đầu vào dữ liệu (a, b) theo tín hiệu chọn (sel).
- sel=0 → y = a
- sel=1 → y = b

## Truth table

| sel | a | b | y |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 |
| 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 |

## Code SystemVerilog
```systemverilog
module mux2to1 (input logic a, b, sel, output logic y);
    assign y = sel ? b : a;
endmodule
```

## Ứng dụng
- Chọn dữ liệu từ hai nguồn.
- Xây dựng MUX lớn hơn (4:1, 8:1) từ MUX 2:1.
- Implement hàm Boolean (MUX as function generator).
