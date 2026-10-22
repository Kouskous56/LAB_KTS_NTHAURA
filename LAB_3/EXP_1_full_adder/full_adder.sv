`timescale 1ns/1ps
// Full adder: S = A ^ B ^ Ci, Co = A&B | A&Ci | B&Ci
module full_adder (
    input  logic A, B, Ci,
    output logic S, Co
);
    assign S  = A ^ B ^ Ci;
    assign Co = (A & B) | (A & Ci) | (B & Ci);
endmodule
