`timescale 1ns/1ps
// 0 to 7 up counter, ripple (asynchronous) with 74LS74
// Each stage toggles (D = ~Q). 74LS74 triggers on the rising edge,
// so the next stage is clocked by the inverted output of the previous one:
//   Q0' rises when Q0 falls -> Q1 counts every 2 clocks
//   Q1' rises when Q1 falls -> Q2 counts every 4 clocks
// Count: 0,1,2,3,4,5,6,7,0...
// A and B are the enable inputs used in the lab (manual Experiment 4):
//   A enables the LSB stage, B enables the next one
//   A=0,B=1 : count frozen
//   A=1,B=0 : only the LSB toggles (0,1,0,1,...)
//   A=B=1   : full 0..7 counting
module counter_0_7 (
    input  logic       clk,
    input  logic       clr,   // async clear, active low
    input  logic       A,
    input  logic       B,
    output logic [2:0] Q
);
    logic [2:0] q;
    logic q0n, q1n;

    dff74ls74 ff0 (.D(A ? ~q[0] : q[0]), .CLK(clk), .PRE(1'b1), .CLR(clr), .Q(q[0]), .QN(q0n));
    dff74ls74 ff1 (.D(B ? ~q[1] : q[1]), .CLK(q0n), .PRE(1'b1), .CLR(clr), .Q(q[1]), .QN(q1n));
    dff74ls74 ff2 (.D(~q[2]),         .CLK(q1n), .PRE(1'b1), .CLR(clr), .Q(q[2]), .QN());

    assign Q = q;
endmodule
