`timescale 1ns/1ps
// 74157 - Quad 2-to-1 multiplexer (select S, active-low strobe G)
module ic_74157 (
    input  logic [3:0] a, b,
    input  logic       s, g_n,
    output logic [3:0] y
);
    always @(*) begin
        if (g_n) y = 4'b0;
        else     y = s ? b : a;
    end
endmodule
