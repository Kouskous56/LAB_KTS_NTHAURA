`timescale 1ns/1ps
// 7410 - Triple 3-input NAND gate
module ic_7410 (input logic [2:0] a, b, c, output logic [2:0] y);
    assign y = ~(a & b & c);
endmodule
