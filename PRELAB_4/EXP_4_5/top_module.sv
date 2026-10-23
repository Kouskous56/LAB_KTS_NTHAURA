`timescale 1ns/1ps
// Nexys A7: CLK100MHZ, BTNC (reset), SW[0]=x_in, LED[1:0]=y_out
module top_module (
    input  logic       CLK100MHZ,
    input  logic       BTNC,
    input  logic [0:0] SW,
    output logic [1:0] LED
);
    fsm_4state_core u (.clk(CLK100MHZ), .rst(BTNC), .x_in(SW[0]), .y_out(LED));
endmodule
