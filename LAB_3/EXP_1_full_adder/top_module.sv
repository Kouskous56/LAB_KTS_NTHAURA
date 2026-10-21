`timescale 1ns/1ps
module top_module (
    input  logic [2:0] SW,   // SW[2]=A, SW[1]=B, SW[0]=Ci
    output logic [15:0] LED
);
    logic S, Co;
    full_adder u (.A(SW[2]), .B(SW[1]), .Ci(SW[0]), .S(S), .Co(Co));
    assign LED[0]    = S;
    assign LED[15]   = Co;
    assign LED[14:1] = 14'b0;
endmodule
