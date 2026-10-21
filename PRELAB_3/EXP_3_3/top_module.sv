`timescale 1ns/1ps
module top_module (
    input  logic [2:0] SW,   // SW[0]=CLK, SW[1]=CLR(active low), SW[2]=unused
    output logic [15:0] LED
);
    logic [2:0] cnt;
    counter_0_7 u (.clk(SW[0]), .clr(SW[1]), .Q(cnt));
    assign LED[2:0]  = cnt;
    assign LED[15]   = ~SW[1];   // LED15 = 1 when counter is cleared
    assign LED[14:3] = 12'b0;
endmodule
