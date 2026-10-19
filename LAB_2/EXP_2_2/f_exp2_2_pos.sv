`timescale 1ns/1ps
// POS form (equivalent): F = (Z | ~Y) & (Y | ~X | ~Z)
module f_exp2_2_pos (
    input  logic X, Y, Z,
    output logic F
);
    assign F = (Z | ~Y) & (Y | ~X | ~Z);
endmodule
