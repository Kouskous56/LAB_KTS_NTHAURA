`timescale 1ns/1ps
module top_module (
    input  logic [2:0] SW,
    output logic [15:0] LED
);
    logic f;
    f_exp2_3 u (.x(SW[0]), .y(SW[1]), .z(SW[2]), .F(f));
    assign LED[0]    = f;
    assign LED[15]   = f;
    assign LED[14:1] = 14'b0;
endmodule
