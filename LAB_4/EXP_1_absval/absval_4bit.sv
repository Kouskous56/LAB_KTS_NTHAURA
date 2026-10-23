`timescale 1ns/1ps
// LAB 4 - Experiment 1: absolute value of a 4-bit number
module absval_4bit (
    input  logic [3:0] A,
    output logic [3:0] S
);
    assign S = A[3] ? (~A + 4'd1) : A;
endmodule
