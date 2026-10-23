`timescale 1ns/1ps
// 7408 - Quad 2-input AND gate
module ic_7408 (input logic [3:0] a, b, output logic [3:0] y);
    assign y = a & b;
endmodule
