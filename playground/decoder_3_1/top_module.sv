`timescale 1ns/1ps
module top_module (
    input  logic [2:0] SW,
    output logic [15:0] LED
);
    logic A,B,C,F;
    assign A = SW[0];
    assign B = SW[1];
    assign C = SW[2];
    f_using_decoder u (.A(A), .B(B), .C(C), .F(F));
    assign LED[0]    = F;
    assign LED[14:1] = 14'b0;
    assign LED[15]   = F;
endmodule
