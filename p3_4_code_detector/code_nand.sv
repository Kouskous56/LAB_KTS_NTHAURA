`timescale 1ns/1ps
// part b: same function using NAND gates only
// Y = NAND(NAND(~A,~B,~C), NAND(A,B,C))  (AND-OR replaced by NAND-NAND)
module code_nand (
    input  logic A, B, C, D, E,
    output logic Y
);
    logic nA, nB, nC, nT0, nT1;
    // inverters built from single-input NAND
    assign nA = ~(A & A);
    assign nB = ~(B & B);
    assign nC = ~(C & C);
    assign nT0 = ~(nA & nB & nC); // = ~(~A·~B·~C)
    assign nT1 = ~(A  & B  & C ); // = ~(A·B·C)
    assign Y   = ~(nT0 & nT1);    // OR of the two product terms
endmodule
