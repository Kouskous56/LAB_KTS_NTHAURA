`timescale 1ns/1ps
// Implement f(x,y,z) = Sigma(0,2,5,7) using 3-to-8 decoder
// f = NAND of selected active-low outputs
module dec_function (
    input  logic x, y, z,
    output logic f
);
    logic [7:0] y_n;
    dec3to8 u (.a({x,y,z}), .g1(1'b1), .g2a_n(1'b0), .g2b_n(1'b0), .y_n(y_n));
    assign f = ~(y_n[0] & y_n[2] & y_n[5] & y_n[7]);
endmodule
