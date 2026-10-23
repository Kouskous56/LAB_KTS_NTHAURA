`timescale 1ns/1ps
// 74238 - 3-to-8 line decoder (active-high outputs, active-low enables)
module ic_74238 (
    input  logic [2:0] a,
    input  logic       g1, g2a_n, g2b_n,
    output logic [7:0] y
);
    always @(*) begin
        if (g1 && !g2a_n && !g2b_n) y = 8'b1 << a;
        else y = 8'b0;
    end
endmodule
