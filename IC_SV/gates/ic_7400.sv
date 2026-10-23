`timescale 1ns/1ps
// 7400 - Quad 2-input NAND gate
module ic_7400 (
    input  logic [3:0] a, b,
    output logic [3:0] y
);
    assign y = ~(a & b);
endmodule
