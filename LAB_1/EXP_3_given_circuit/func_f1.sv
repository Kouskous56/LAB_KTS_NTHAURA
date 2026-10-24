`timescale 1ns/1ps
// LAB 1 Exp 3: F1 = given circuit (Figure 1.6) = x + y + z
module func_f1 (
    input  logic x, y, z,
    output logic f
);
    assign f = x | y | z;
endmodule
