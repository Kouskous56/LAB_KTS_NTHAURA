`timescale 1ns/1ps
// EXP_3_2: 4-bit full adder / subtractor using 74LS283
// Sel=0: S = A + B        (Cin=0, B passed)
// Sel=1: S = A - B        (Cin=1, B inverted -> A + ~B + 1)
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
