# EX_03 ? Decoder 3-to-8 (nh? 74LS138)

## Kh?i ni?m
Decoder 3-to-8 bi?n m? 3-bit th?nh m?t trong 8 ??u ra (active-low).
C? 3 ch?n enable: E0 (active HIGH), E1bar, E2bar (active LOW).

## Code SystemVerilog
```systemverilog
module dec3to8 (input logic [2:0] a, input logic g1, g2a_n, g2b_n, output logic [7:0] y_n);
    always_comb begin
        if (g1 && !g2a_n && !g2b_n) y_n = ~(8'b1 << a);
        else y_n = 8'hFF;
    end
endmodule
```

## ?ng d?ng
- IC 74LS138 l? decoder 3-to-8 (active-low).
- Gi?i m? ??a ch? trong h? th?ng s?.
- Tri?n khai h?m Boolean (decoder as function generator).
