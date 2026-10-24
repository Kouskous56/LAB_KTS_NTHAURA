# EX_01 ? D Flip-Flop c? b?n (positive edge, async reset)

## Kh?i ni?m
D Flip-Flop l?u gi? tr? ??u v?o D t?i c?nh l?n c?a clock.
- Reset async (active low): q = 0 ngay khi rst_n=0.
- T?i c?nh l?n clk: q = d.
- q_n = ~q (b? sung).

## Truth table

| rst_n | clk | d | q (next) |
|---|---|---|---|
| 0 | X | X | 0 (reset) |
| 1 | ? | 0 | 0 |
| 1 | ? | 1 | 1 |
| 1 | ?/stable | X | gi? q |

## Code SystemVerilog
```systemverilog
module dff_basic (input logic clk, rst_n, d, output logic q, q_n);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin q <= 0; q_n <= 1; end
        else begin q <= d; q_n <= ~d; end
    end
endmodule
```

## ?ng d?ng
- L?u tr? 1 bit d? li?u.
- Register, pipeline.
- IC 74LS74 (dual D-FF).
