`timescale 1ns/1ps
// 2-input NAND gate (primitive)
module nand_2 (
    input  logic u, v,
    output logic t
);
    assign t = ~(u & v);
endmodule
