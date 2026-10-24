`timescale 1ns/1ps
// LAB 1 Exp 4: f(x,y,z) = Sigma(1,2,4,7) = xbar.ybar.z + xbar.y.zbar + x.ybar.zbar + x.y.z
module func_exp4 (
    input  logic x, y, z,
    output logic f
);
    assign f = (~x & ~y & z) | (~x & y & ~z) | (x & ~y & ~z) | (x & y & z);
endmodule
