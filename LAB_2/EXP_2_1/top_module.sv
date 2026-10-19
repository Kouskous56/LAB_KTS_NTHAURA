`timescale 1ns/1ps
// Nexys A7 top: SW[2:0] -> {z,y,x}, LED output f
module top_module (
    input  logic [2:0] SW,
    output logic [15:0] LED
);
    logic f;
    f_exp2_1 u (.x(SW[0]), .y(SW[1]), .z(SW[2]), .f(f));
    assign LED[0]    = f;
    assign LED[15]   = f;
    assign LED[14:1] = 14'b0;
endmodule
