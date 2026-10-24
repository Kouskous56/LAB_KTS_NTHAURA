`timescale 1ns/1ps
module top_module (
    input  logic [2:0]  SW,
    output logic [15:0] LED
);
    logic f;
    func_exp2 u (.x(SW[2]), .y(SW[1]), .z(SW[0]), .f(f));
    assign LED[0]    = f;
    assign LED[15:1] = 15'b0;
endmodule
