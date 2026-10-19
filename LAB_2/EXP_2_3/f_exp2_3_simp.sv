`timescale 1ns/1ps
// Simplified form (De Morgan): F = x & ~y  (independent of z)
module f_exp2_3_simp (
    input  logic x, y, z,
    output logic F
);
    assign F = x & ~y;
endmodule
