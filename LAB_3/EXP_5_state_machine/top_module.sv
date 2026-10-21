`timescale 1ns/1ps
module top_module (
    input  logic [2:0] SW,   // SW[0]=CLK, SW[1]=CLR(active low), SW[2]=X
    output logic [15:0] LED
);
    logic [1:0] S;
    fsm_fig34 u (.clk(SW[0]), .clr(SW[1]), .X(SW[2]), .S(S));
    assign LED[1:0]  = S;      // 00=A 01=B 10=C 11=D
    assign LED[15]   = ~SW[1];  // LED15 = 1 when in reset
    assign LED[14:2] = 13'b0;
endmodule
