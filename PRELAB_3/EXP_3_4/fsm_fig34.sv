`timescale 1ns/1ps
// Sequential circuit of Figure 3.4 (same diagram as Figure 3.6)
//   A(00): X=0 -> A,  X=1 -> B
//   B(01): X=0 -> A,  X=1 -> D
//   C(10): X=0 -> A,  X=1 -> B
//   D(11): X=0 -> A,  X=1 -> C
// Next state:
//   S1+ = X & S0
//   S0+ = X & (S1' + S0')      (uses the inverted outputs of the flip-flops)
// Needed ICs: 74LS74 (2 FF), 74LS08 (2 AND), 74LS32 (1 OR)
// Async clear (active low) resets the machine to state A.
module fsm_fig34 (
    input  logic       clk,
    input  logic       clr,
    input  logic       X,
    output logic [1:0] S      // 00=A 01=B 10=C 11=D
);
    logic [1:0] q;
    logic q1n, q0n;
    logic s1p, s0p;

    assign s1p = X & q[0];
    assign s0p = X & (q1n | q0n);

    dff74ls74 ff1 (.D(s1p), .CLK(clk), .PRE(1'b1), .CLR(clr), .Q(q[1]), .QN(q1n));
    dff74ls74 ff0 (.D(s0p), .CLK(clk), .PRE(1'b1), .CLR(clr), .Q(q[0]), .QN(q0n));

    assign S = q;
endmodule
