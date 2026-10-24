`timescale 1ns/1ps
// LAB 1 Exp 1: f(x,y,z) = xbar.y + ybar.z  (AND-OR form)
module func_and_or (
    input  logic x, y, z,
    output logic f
);
    assign f = (~x & y) | (~y & z);
endmodule
