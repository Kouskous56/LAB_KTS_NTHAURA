`timescale 1ns/1ps
// EXP_3_1: Full Adder (combinational)
// S  = A xor B xor Ci
// Co = A&B | A&Ci | B&Ci
module full_adder (
    input  logic A, B, Ci,
    output logic S, Co
);
    assign S  = A ^ B ^ Ci;
    assign Co = (A & B) | (A & Ci) | (B & Ci);
endmodule
