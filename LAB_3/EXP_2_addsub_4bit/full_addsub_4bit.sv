`timescale 1ns/1ps
// 4-bit adder/subtractor with 74LS283
//   Sel=0: S = A + B
//   Sel=1: S = A - B   (A + ~B + 1, XOR 4 bits of B with Sel, Cin = Sel)
module full_addsub_4bit (
    input  logic       Sel,
    input  logic [3:0] A, B,
    output logic [3:0] S,
    output logic       Cout
);
    logic [3:0] Bx;
    assign Bx = B ^ {4{Sel}};
    adder74ls283 u (.A(A), .B(Bx), .Cin(Sel), .S(S), .Cout(Cout));
endmodule
