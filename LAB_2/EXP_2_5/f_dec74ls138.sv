`timescale 1ns/1ps
// EXP_2_5: f(x,y,z) = Sigma(0,2,5,7) using 74LS138
// 74LS138 outputs are active-low, so f = 1 when selected output is 0.
module f_dec74ls138 (
    input  logic x, y, z,
    output logic f
);
    logic [7:0] Y;
    dec74ls138 u (
        .E1(1'b0), .E2(1'b0), .E3(1'b1),   // enabled
        .A({x, y, z}),
        .Y(Y)
    );
    // minterms 0,2,5,7 -> Y0,Y2,Y5,Y7 are low when selected
    assign f = (~Y[0]) | (~Y[2]) | (~Y[5]) | (~Y[7]);
endmodule
