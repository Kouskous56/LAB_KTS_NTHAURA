`timescale 1ns/1ps
module f_using_decoder (
    input  logic A, B, C,
    output logic F
);
    logic Y0,Y1,Y2,Y3;
    decoder_3_1 u (.E(~A), .X1(B), .X0(C), .Y0(Y0), .Y1(Y1), .Y2(Y2), .Y3(Y3));
    assign F = Y0 | Y2; // m4,m6
endmodule
