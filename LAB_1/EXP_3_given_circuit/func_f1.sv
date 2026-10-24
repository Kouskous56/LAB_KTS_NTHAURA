`timescale 1ns/1ps
// LAB 1 Exp 3: F1 = given circuit (Figure 1.6): F = xbar.y + z
// Original circuit: OR(xbar,B) -> NAND with Cbar; NAND(B,Cbar); XNOR of the two.
module func_f1 (
    input  logic x, y, z,
    output logic f
);
    // F1 = xbar.y + z  (derived from the given circuit)
    assign f = (~x & y) | z;
endmodule
