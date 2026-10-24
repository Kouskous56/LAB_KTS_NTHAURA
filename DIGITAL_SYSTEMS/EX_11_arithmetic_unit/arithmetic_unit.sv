`timescale 1ns/1ps
// Arithmetic Unit (AU): 4-bit, supports A+B, A+1, A-B, A-B-1
// Control: S1 S0
//   00: A + B
//   01: A + 1
//   10: A - B
//   11: A - B - 1
module arithmetic_unit (
    input  logic [3:0] A, B,
    input  logic       S1, S0,
    output logic [3:0] F,
    output logic       Cout
);
    // Internal signals
    logic [3:0] x, y;
    logic       cin;
    logic [3:0] c;  // carry chain

    // x = A (always)
    assign x = A;

    // y = (B XOR S1) AND (S1 OR NOT S0)
    //   S1=0,S0=0: y = B  (A+B)
    //   S1=0,S0=1: y = 0  (A+1)
    //   S1=1,S0=0: y = ~B (A-B)
    //   S1=1,S0=1: y = ~B (A-B-1)
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin : gen_y
            assign y[i] = (B[i] ^ S1) & (S1 | ~S0);
        end
    endgenerate

    // Cin = S0 XOR S1
    assign cin = S0 ^ S1;

    // Ripple carry adder (4 full adders)
    full_adder fa0 (.x(x[0]), .y(y[0]), .cin(cin),  .sum(F[0]), .cout(c[0]));
    full_adder fa1 (.x(x[1]), .y(y[1]), .cin(c[0]), .sum(F[1]), .cout(c[1]));
    full_adder fa2 (.x(x[2]), .y(y[2]), .cin(c[1]), .sum(F[2]), .cout(c[2]));
    full_adder fa3 (.x(x[3]), .y(y[3]), .cin(c[2]), .sum(F[3]), .cout(Cout));
endmodule
