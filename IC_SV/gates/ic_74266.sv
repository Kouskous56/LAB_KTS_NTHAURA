`timescale 1ns/1ps
// 74266 - Quad 2-input XNOR gate (open collector outputs)
module ic_74266 (input logic [3:0] a, b, output logic [3:0] y);
    assign y = ~(a ^ b);
endmodule
