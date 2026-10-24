`timescale 1ns/1ps
// Prelab Q12: f(x,y,z) = Sigma(0,3,4,7) = y XNOR z (independent of x)
module func_prelab_q12 (
    input  logic x, y, z,
    output logic f
);
    assign f = ~(y ^ z);
endmodule
