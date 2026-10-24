`timescale 1ns/1ps
// LAB 1 Exp 1: f = xbar.y + y.z  (NAND-only form, 4 cong NAND2)
// n1 = x NAND x = xbar
// n2 = NAND(n1, y) = NOT(xbar.y)
// n3 = NAND(y, z) = NOT(y.z)
// f  = NAND(n2, n3) = xbar.y + y.z
module func_nand (
    input  logic x, y, z,
    output logic f
);
    logic xn, a, b;
    assign xn = ~(x & x);   // xbar (NAND as inverter)
    assign a  = ~(xn & y);  // NOT(xbar.y)
    assign b  = ~(y & z);   // NOT(y.z)
    assign f  = ~(a & b);   // NAND of a,b
endmodule
