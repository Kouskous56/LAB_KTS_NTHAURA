`timescale 1ns/1ps
// LAB 1 Exp 5: f(x,y,z) = Sigma(2,3,5,7) = ~x&y | x&z
module func_exp5 (
    input  logic x, y, z,
    output logic f
);
    assign f = (~x & y) | (x & z);
endmodule
