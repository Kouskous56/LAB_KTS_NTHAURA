`timescale 1ns/1ps
// EXP_3_4: sequential circuit of Figure 3.4 (same diagram as Figure 3.6)
// States: A=00, B=01, C=10, D=11
// Transitions (current state, X) -> next state:
//   A(00): X=0 -> A,  X=1 -> B
//   B(01): X=0 -> A,  X=1 -> D
//   C(10): X=0 -> A,  X=1 -> B
//   D(11): X=0 -> A,  X=1 -> C
// Next-state equations (D0/D1 of the two 74LS74 flip-flops):
//   S1+ = X & S0 & ~S1
//   S0+ = X & ~(S1 & S0)
// Async CLR (active low) resets the machine to state A (00).
module fsm_fig34 (
    input  logic       clk,
    input  logic       clr,   // async clear (active low) -> state A
    input  logic       X,
    output logic [1:0] S      // state: 00=A 01=B 10=C 11=D
);
    logic [1:0] q;
    logic s1p, s0p;

    assign s1p = X &  q[0] & ~q[1];
    assign s0p = X & ~(q[1] & q[0]);

    dff74ls74 ff1 (.D(s1p), .CLK(clk), .PRE(1'b1), .CLR(clr), .Q(q[1]), .QN());
    dff74ls74 ff0 (.D(s0p), .CLK(clk), .PRE(1'b1), .CLR(clr), .Q(q[0]), .QN());

    assign S = q;
endmodule
