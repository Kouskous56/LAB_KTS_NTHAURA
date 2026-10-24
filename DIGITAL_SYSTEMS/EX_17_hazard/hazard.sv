`timescale 1ns/1ps
// Cau 3: Static-1 Hazard
// Original circuit: Z = (X1 AND X2) OR (X3 AND NOT X2)
// With X1=1, X3=1: Z = X2 OR NOT X2 = 1 (should always be 1)
// But due to gate delays, a glitch occurs when X2 transitions 1->0.
//
// Gate delays: each gate = 10ns
// Y1 = NOT(X1 AND X2)  [NAND, 10ns]
// X2_bar = NOT(X2)     [NOT, 10ns]
// Y2 = NOT(X3 AND X2_bar) [NAND, 10ns]
// Z = NOT(Y1 AND Y2)   [NAND, 10ns]

module hazard_circuit (
    input  logic X1, X2, X3,
    output logic Z,
    // Intermediate signals for observation
    output logic Y1, Y2, X2_bar
);
    // Gate delays: 10ns each
    assign #10 Y1 = ~(X1 & X2);
    assign #10 X2_bar = ~X2;
    assign #10 Y2 = ~(X3 & X2_bar);
    assign #10 Z = ~(Y1 & Y2);
endmodule

// Fixed circuit: add consensus term X1 AND X3
// Z_fixed = X1*X2 + X3*X2_bar + X1*X3
// In NAND form: Z = NAND(NAND(Y1,Y2), Y3) where Y3 = NAND(X1,X3)
// Actually: Z = NOT(Y1*Y2*Y3) with 2-input NAND cascade
module hazard_fixed (
    input  logic X1, X2, X3,
    output logic Z,
    output logic Y1, Y2, Y3, t, t_bar
);
    assign #10 Y1 = ~(X1 & X2);           // NOT(X1*X2)
    assign #10 Y2 = ~(X3 & ~X2);           // NOT(X3*X2_bar)  (NOT gate included in delay)
    assign #10 Y3 = ~(X1 & X3);            // NOT(X1*X3) consensus term
    assign #10 t = ~(Y1 & Y2);             // NOT(Y1*Y2) = X1*X2 + X3*X2_bar
    assign #10 t_bar = ~(t & t);           // NOT(t) = NOT(X1*X2 + X3*X2_bar)
    assign #10 Z = ~(t_bar & Y3);          // NOT(NOT(t)*Y3) = t + X1*X3
endmodule
