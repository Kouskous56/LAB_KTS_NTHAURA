`timescale 1ns/1ps
// Nexys A7: CLK100MHZ, BTNC reset, SW[0]=x, LED[0]=z
module top_module (
    input  logic        CLK100MHZ,
    input  logic        BTNC,
    input  logic [0:0]  SW,
    output logic [15:0] LED
);
    logic z;
    seq_det_3 u (.clk(CLK100MHZ), .rst(BTNC), .x(SW[0]), .z(z));
    assign LED[0]    = z;
    assign LED[15:1] = 15'b0;
endmodule
