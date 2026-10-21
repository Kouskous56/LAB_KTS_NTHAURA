`timescale 1ns/1ps
// EXP_3_3: 0->7 up counter built from 74LS74 D flip-flops (asynchronous / ripple)
// Each stage toggles (D = ~Q). 74LS74 is rising-edge triggered, so the next
// stage is clocked by the INVERTED output of the previous stage (Q'):
//   q0' rises when q0 falls  -> q1 increments every 2 clocks
//   q1' rises when q1 falls  -> q2 increments every 4 clocks
// Count sequence: 0,1,2,3,4,5,6,7,0,...
// ICs: one 74LS74 package holds 2 FFs -> 2 packages for 3 FFs.
module counter_0_7 (
    input  logic       clk,   // master clock
    input  logic       clr,   // async clear (active low) -> reset to 000
    output logic [2:0] Q      // count value
);
    logic [2:0] q;
    logic q0n, q1n;

    dff74ls74 ff0 (.D(~q[0]), .CLK(clk), .PRE(1'b1), .CLR(clr), .Q(q[0]), .QN(q0n));
    dff74ls74 ff1 (.D(~q[1]), .CLK(q0n), .PRE(1'b1), .CLR(clr), .Q(q[1]), .QN(q1n));
    dff74ls74 ff2 (.D(~q[2]), .CLK(q1n), .PRE(1'b1), .CLR(clr), .Q(q[2]), .QN());

    assign Q = q;
endmodule
