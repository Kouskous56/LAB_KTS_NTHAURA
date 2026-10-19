`timescale 1ns/1ps
// EXP_2_2: F = sum m(0,1,3,4,7)  (from Table 2.3)
// minimized SOP: F = (Y & Z) | (~X & ~Y) | (~Y & ~Z)
module f_exp2_2 (
    input  logic X, Y, Z,
    output logic F
);
    assign F = (Y & Z) | (~X & ~Y) | (~Y & ~Z);
endmodule
