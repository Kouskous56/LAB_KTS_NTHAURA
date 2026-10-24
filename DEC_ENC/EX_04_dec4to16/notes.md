# EX_04 ? Decoder 4-to-16

## Kh?i ni?m
Decoder 4-to-16 bi?n m? 4-bit th?nh m?t trong 16 ??u ra (one-hot).
C?n 4 bit input, t?o 16 output.

## Code SystemVerilog
```systemverilog
module dec4to16 (input logic [3:0] a, input logic en, output logic [15:0] y);
    always_comb begin
        if (en) begin y = 16'b0; y[a] = 1'b1; end
        else y = 16'b0;
    end
endmodule
```

## ?ng d?ng
- Gi?i m? ??a ch? trong h? th?ng nh? (memory address decoding).
- Ch?n m?t trong 16 thi?t b? ngo?i vi.
- X?y d?ng t? decoder 3-to-8 + logic enable.
