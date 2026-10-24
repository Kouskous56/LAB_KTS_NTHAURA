`timescale 1ns/1ps
// D Latch: transparent when enable high
module d_latch (
    input  logic d, en,
    output logic q, q_n
);
    always_comb begin
        if (en) begin q = d; q_n = ~d; end
    end
endmodule
