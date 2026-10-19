`timescale 1ns/1ps
// Nexys A7 top: SW[2:0] -> {x,y,z}, LED[15] = f
module top_module (
    input  logic [2:0] SW,
    output logic [15:0] LED
);
    logic f;
    f_exp2_1 u (.x(SW[2]), .y(SW[1]), .z(SW[0]), .f(f));
    assign LED[15]   = f;
    assign LED[14:0] = 15'b0;
endmodule
