`timescale 1ns/1ps
// LAB 1 Exp 1: f = xbar.y + ybar.z  (NAND-only form)
// f = NOT( NOT(xbar.y) AND NOT(ybar.z) )
module func_nand (
    input  logic x, y, z,
    output logic f
);
    logic xn, yn, a, b;
    assign xn = ~(x & x);   // xbar (NAND as inverter)
    assign yn = ~(y & y);   // ybar
    assign a  = ~(xn & y);  // NOT(xbar.y)
    assign b  = ~(yn & z);  // NOT(ybar.z)
    assign f  = ~(a & b);   // NAND of a,b
endmodule
