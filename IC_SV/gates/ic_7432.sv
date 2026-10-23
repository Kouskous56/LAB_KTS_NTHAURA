`timescale 1ns/1ps
// 7432 - Quad 2-input OR gate
module ic_7432 (input logic [3:0] a, b, output logic [3:0] y);
    assign y = a | b;
endmodule
