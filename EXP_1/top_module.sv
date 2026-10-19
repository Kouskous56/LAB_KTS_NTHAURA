`timescale 1ns/1ps
// Nexys A7 top: SW[2:0] -> {z,y,x}, LED[0] = f_original, LED[15] = f_simplified
module top_module (
    input  logic [2:0] SW,
    output logic [15:0] LED
);
    logic f0, f1;
    f_original  u0 (.x(SW[0]), .y(SW[1]), .z(SW[2]), .f(f0));
    f_simplified u1 (.x(SW[0]), .y(SW[1]), .z(SW[2]), .f(f1));
    assign LED[0]    = f0;
    assign LED[15]   = f1;
    assign LED[14:1] = 14'b0;
endmodule
