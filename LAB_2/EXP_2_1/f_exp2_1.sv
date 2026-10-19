`timescale 1ns/1ps
// EXP_2_1: f = x'yz + (xy)'z + xy  (as given, NOT simplified)
module f_exp2_1 (
    input  logic x, y, z,
    output logic f
);
    logic t1, t2, t3;
    assign t1 = ~x & y & z;        // x'·y·z
    assign t2 = ~(x & y) & z;      // (xy)'·z
    assign t3 =  x & y;            // xy
    assign f  = t1 | t2 | t3;
endmodule
