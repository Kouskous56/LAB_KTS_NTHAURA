`timescale 1ns/1ps
// 7486 - Quad 2-input XOR gate
module ic_7486 (input logic [3:0] a, b, output logic [3:0] y);
    assign y = a ^ b;
endmodule
