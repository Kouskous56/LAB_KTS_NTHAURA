`timescale 1ns/1ps
// 74139 - Dual 2-to-4 line decoder (active-low outputs)
module ic_74139 (
    input  logic [1:0] a0, a1,
    input  logic       g0_n, g1_n,
    output logic [3:0] y0_n, y1_n
);
    always @(*) begin
        y0_n = g0_n ? 4'hF : ~(4'b1 << a0);
        y1_n = g1_n ? 4'hF : ~(4'b1 << a1);
    end
endmodule
