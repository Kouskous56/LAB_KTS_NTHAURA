# EX_05 ? Decoder as Boolean function generator

## Kh?i ni?m
Decoder c? th? d?ng ?? tri?n khai h?m Boolean. V?i h?m 3 bi?n, d?ng decoder 3-to-8:
- Address lines = c?c bi?n (x, y, z).
- Enable = 1 (active).
- Output = NAND c?a c?c output active-low t?i c?c v? tr? minterm.

## H?m
f = ?m(0,2,5,7) = x??? + x?y? + x?z + xyz
B?ng ch?n l?: 1,0,1,0,0,1,0,1.

## Code SystemVerilog
```systemverilog
module dec_function (input logic x, y, z, output logic f);
    logic [7:0] y_n;
    dec3to8 u (.a({x,y,z}), .g1(1'b1), .g2a_n(1'b0), .g2b_n(1'b0), .y_n(y_n));
    assign f = ~(y_n[0] & y_n[2] & y_n[5] & y_n[7]);
endmodule
```

## So s?nh v?i MUX
- MUX: data inputs = gi? tr? h?m, select = bi?n, output = f (direct).
- Decoder: address = bi?n, outputs = minterm (active-low), f = NAND/NOR c?a selected outputs.
- Decoder c?n th?m c?ng NAND/NOR ?? k?t h?p outputs.
