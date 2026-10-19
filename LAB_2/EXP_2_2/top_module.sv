`timescale 1ns/1ps
module top_module (
    input  logic [2:0] SW,
    output logic [15:0] LED
);
    logic f;
    f_exp2_2 u (.X(SW[2]), .Y(SW[1]), .Z(SW[0]), .F(f));
    assign LED[15]   = f;
    assign LED[14:0] = 15'b0;
endmodule
