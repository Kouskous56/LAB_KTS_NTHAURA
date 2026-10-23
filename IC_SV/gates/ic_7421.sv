`timescale 1ns/1ps
// 7421 - Dual 4-input AND gate
module ic_7421 (input logic [1:0] a, b, c, d, output logic [1:0] y);
    assign y = a & b & c & d;
endmodule
