`timescale 1ns/1ps
// 74LS283: 4-bit ripple-carry adder model
module adder74ls283 (
    input  logic [3:0] A, B,
    input  logic       Cin,
    output logic [3:0] S,
    output logic       Cout
);
    logic [4:0] sum;
    assign sum  = A + B + Cin;
    assign S    = sum[3:0];
    assign Cout = sum[4];
endmodule
