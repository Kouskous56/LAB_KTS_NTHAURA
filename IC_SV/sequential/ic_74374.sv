`timescale 1ns/1ps
// 74374 - Octal D flip-flop with 3-state outputs (OE active low, CLK rising edge)
module ic_74374 (
    input  logic       clk,
    input  logic [7:0] d,
    input  logic       oe_n,
    output tri [7:0]   q
);
    logic [7:0] ff;
    always @(posedge clk) ff <= d;
    assign q = oe_n ? 8'bz : ff;
endmodule
