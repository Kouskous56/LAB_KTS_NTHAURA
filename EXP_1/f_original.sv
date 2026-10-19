`timescale 1ns/1ps
// EXP_1: f = x'yz + (xy)'z + xy  (expression as given in the problem)
module f_original (
    input  logic x, y, z,
    output logic f
);
    logic t1, t2, t3;
    assign t1 = ~x & y & z;        // x'·y·z
    assign t2 = ~(x & y) & z;      // (xy)'·z
    assign t3 =  x & y;            // xy
    assign f  = t1 | t2 | t3;
endmodule
