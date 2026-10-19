`timescale 1ns/1ps
// EXP_1 simplified: f = xy + z
// x'yz + (xy)'z + xy
//   = x'z + y'z + xy          (x'yz redundant; (xy)' = x'+y')
//   = (xy)'z + xy
//   = xy + z                  (A + A'B = A + B)
module f_simplified (
    input  logic x, y, z,
    output logic f
);
    assign f = (x & y) | z;
endmodule
