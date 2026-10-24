`timescale 1ns/1ps
// Parametric N-to-2^N Decoder
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

// Parametric 2^N-to-N Priority Encoder
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
