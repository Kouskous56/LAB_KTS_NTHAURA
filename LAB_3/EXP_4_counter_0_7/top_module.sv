`timescale 1ns/1ps
module top_module (
    input  logic [4:0] SW,   // SW[0]=CLK, SW[1]=CLR, SW[2]=A, SW[3]=B
    output logic [15:0] LED
);
    logic [2:0] cnt;
    counter_0_7 u (.clk(SW[0]), .clr(SW[1]), .A(SW[2]), .B(SW[3]), .Q(cnt));
    assign LED[2:0]  = cnt;
    assign LED[15]   = ~SW[1];   // LED15 = 1 when counter is cleared
    assign LED[14:3] = 12'b0;
endmodule
