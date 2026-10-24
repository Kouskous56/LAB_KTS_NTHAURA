`timescale 1ns/1ps
// LAB 1 Exp 3: F2 = optimized form = x + y + z
module func_f2 (
    input  logic x, y, z,
    output logic f
);
    assign f = x | y | z;
endmodule
