# EX_02 ? Decoder 2-to-4 (active low, nh? 74LS139)

## Kh?i ni?m
Decoder 2-to-4 v?i output active-low v? enable active-low.
- Khi enable=0: output ???c ch?n = 0, c?c output kh?c = 1.
- Khi enable=1: t?t c? output = 1 (disabled).

## Code SystemVerilog
```systemverilog
module dec2to4_al (input logic [1:0] a, input logic g_n, output logic [3:0] y_n);
    always_comb begin
        if (g_n) y_n = 4'b1111;
        else     y_n = ~(4'b1 << a);
    end
endmodule
```

## ?ng d?ng
- IC 74LS139 l? dual 2-to-4 decoder (active-low).
- Gi?i m? ??a ch? trong h? th?ng s?.
