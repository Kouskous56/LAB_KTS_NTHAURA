`timescale 1ns/1ps
// Nexys A7: SW[0]=CLK, SW[1]=CLR, LED[2:0]=count, LED[15]=1 while cleared
module top_module (
    input  logic [2:0] SW,
    output logic [15:0] LED
);
    logic [2:0] cnt;
    counter_0_7 u (.clk(SW[0]), .clr(SW[1]), .Q(cnt));
    assign LED[2:0]  = cnt;
    assign LED[15]   = ~SW[1];
    assign LED[14:3] = 12'b0;
endmodule
