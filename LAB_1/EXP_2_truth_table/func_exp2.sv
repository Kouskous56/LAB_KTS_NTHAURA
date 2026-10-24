`timescale 1ns/1ps
// LAB 1 Exp 2: f(x,y,z) = Sigma(1,2,6) = xbar.ybar.z + xbar.y.zbar + x.y.zbar
module func_exp2 (
    input  logic x, y, z,
    output logic f
);
    assign f = (~x & ~y & z) | (~x & y & ~z) | (x & y & ~z);
endmodule
