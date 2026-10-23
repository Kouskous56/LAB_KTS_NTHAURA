`timescale 1ns/1ps
// 74183 - Dual 4? no, dual 1-bit? Actually 74183 = dual 4-bit? No: 74183 is dual full adder (2 independent 1-bit full adders)
// Modeled as two 1-bit full adders
module ic_74183 (
    input  logic a1, b1, c1,
    input  logic a2, b2, c2,
    output logic s1, co1,
    output logic s2, co2
);
    assign s1  = a1 ^ b1 ^ c1;
    assign co1 = (a1 & b1) | (a1 & c1) | (b1 & c1);
    assign s2  = a2 ^ b2 ^ c2;
    assign co2 = (a2 & b2) | (a2 & c2) | (b2 & c2);
endmodule
