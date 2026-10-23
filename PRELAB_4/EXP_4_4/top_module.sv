`timescale 1ns/1ps
// Nexys A7: CLK100MHZ -> clk, BTNC -> reset (active high), LED[0] = divided clock
module top_module (
    input  logic        CLK100MHZ,
    input  logic        BTNC,
    output logic [15:0] LED
);
    logic out;
    clock_divider_core u (.clk_in(CLK100MHZ), .rst_in(BTNC), .out_signal(out));
    assign LED[0]    = out;
    assign LED[15:1] = 15'b0;
endmodule
