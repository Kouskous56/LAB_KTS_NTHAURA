`timescale 1ns/1ps
// Nexys A7 top: SW[4:0] -> {E,D,C,B,A}, LED[0]=part a, LED[15]=part b
module top_module (
    input  logic [4:0] SW,
    output logic [15:0] LED
);
    logic yA, yN;
    code_andor ua (.A(SW[0]), .B(SW[1]), .C(SW[2]), .D(SW[3]), .E(SW[4]), .Y(yA));
    code_nand  un (.A(SW[0]), .B(SW[1]), .C(SW[2]), .D(SW[3]), .E(SW[4]), .Y(yN));
    assign LED[0]    = yA;
    assign LED[15]   = yN;
    assign LED[14:1] = 14'b0;
endmodule
