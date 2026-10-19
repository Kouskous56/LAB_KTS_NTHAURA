`timescale 1ns/1ps
// EXP_2_4: f(x,y,z) = Sigma(1,2,4,7) implemented with 74LS151
// data inputs I0..I7 = f for minterm 0..7 = 0,1,1,0,1,0,0,1
module f_mux74ls151 (
    input  logic x, y, z,
    output logic f
);
    logic Y, Ybar;
    mux74ls151 u (
        .E(1'b0),
        .S({x, y, z}),
        .I(8'b10010110),   // I7..I0
        .Y(Y),
        .Ybar(Ybar)
    );
    assign f = Y;
endmodule
