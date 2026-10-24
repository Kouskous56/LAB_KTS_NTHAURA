`timescale 1ns/1ps
// 74138 - 3-to-8 line decoder (active-low outputs, active-low enables)
module ic_74138 (
    input  logic [2:0] a,
    input  logic       g1, g2a_n, g2b_n,
    output logic [7:0] y_n
);
    always @(*) begin
        if (g1 && !g2a_n && !g2b_n) y_n = ~(8'b1 << a);
        else y_n = 8'hFF;
    end
endmodule
