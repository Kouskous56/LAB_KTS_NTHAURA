`timescale 1ns/1ps
// PRELAB 4 - Preparation 1: Full Adder (Manual Fig. 4.1)
module FA_ex1 (
    input  logic a, b, ci,
    output logic s, co
);
    assign s  = a ^ b ^ ci;
    assign co = (a & b) | (a & ci) | (b & ci);
endmodule
