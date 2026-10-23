`timescale 1ns/1ps
// 7420 - Dual 4-input NAND gate
module ic_7420 (input logic [1:0] a, b, c, d, output logic [1:0] y);
    assign y = ~(a & b & c & d);
endmodule
