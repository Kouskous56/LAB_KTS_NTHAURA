`timescale 1ns/1ps
// Nexys A7: SW[0]=CLK, SW[1]=CLR, SW[2]=X
//            LED[1:0]=state (00=A 01=B 10=C 11=D), LED[15]=1 while cleared
module top_module (
    input  logic [2:0] SW,
    output logic [15:0] LED
);
    logic [1:0] S;
    fsm_fig34 u (.clk(SW[0]), .clr(SW[1]), .X(SW[2]), .S(S));
    assign LED[1:0]  = S;
    assign LED[15]   = ~SW[1];
    assign LED[14:2] = 13'b0;
endmodule
