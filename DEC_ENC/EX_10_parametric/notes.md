# EX_10 — Parametric decoder v? encoder

## Kh?i ni?m
S? d?ng parameter ?? t?o decoder/encoder t?ng qu?t v?i N ??u v?o/??u ra.
- N ph?i l? l?y th?a c?a 2 (2, 4, 8, 16, ...).
- S? bit select/input = $clog2(N).

## Code SystemVerilog
```systemverilog
module dec_param #(parameter N = 3) (
    input  logic [N-1:0] a,
    input  logic         en,
    output logic [2**N-1:0] y
);
    always_comb begin
        if (en) begin y = '0; y[a] = 1'b1; end
        else y = '0;
    end
endmodule

module enc_param #(parameter N = 3) (
    input  logic [2**N-1:0] d,
    output logic [N-1:0] y,
    output logic        valid
);
    always_comb begin
        y = '0; valid = 1'b0;
        for (int i = 2**N - 1; i >= 0; i--) begin
            if (d[i]) begin y = i[N-1:0]; valid = 1'b1; break; end
        end
    end
endmodule
```

## ?ng d?ng
- T?i s? d?ng code cho nhi?u k?ch th??c.
- FPGA: instantiate v?i N kh?c nhau trong c?ng design.
- Software-defined hardware (parameterization).
