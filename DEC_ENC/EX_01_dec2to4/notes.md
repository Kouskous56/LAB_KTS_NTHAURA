# EX_01 ? Decoder 2-to-4 (active high)

## Kh?i ni?m
Decoder 2-to-4 bi?n m? 2-bit (a[1:0]) th?nh m?t trong 4 ??u ra (y[0..3]).
Ch? c? m?t ??u ra ? m?c 1 t?i m?t th?i ?i?m (one-hot).

## Truth table

| a1 | a0 | y3 | y2 | y1 | y0 |
|---|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 | 1 |
| 0 | 1 | 0 | 0 | 1 | 0 |
| 1 | 0 | 0 | 1 | 0 | 0 |
| 1 | 1 | 1 | 0 | 0 | 0 |

## Code SystemVerilog
```systemverilog
module dec2to4 (input logic [1:0] a, output logic [3:0] y);
    always_comb begin
        y = 4'b0;
        y[a] = 1'b1;
    end
endmodule
```

## ?ng d?ng
- Gi?i m? ??a ch? (address decoding).
- Ch?n m?t trong nhi?u thi?t b?.
- X?y d?ng decoder l?n h?n (3-to-8, 4-to-16).
