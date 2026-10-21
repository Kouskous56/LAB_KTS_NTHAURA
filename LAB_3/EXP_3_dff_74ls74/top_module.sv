`timescale 1ns/1ps
module top_module (
    input  logic [3:0] SW,   // SW[0]=D, SW[1]=CLK, SW[2]=PRE(bar), SW[3]=CLR(bar)
    output logic [15:0] LED
);
    logic Q, QN;
    dff74ls74 u (.D(SW[0]), .CLK(SW[1]), .PRE(SW[2]), .CLR(SW[3]), .Q(Q), .QN(QN));
    assign LED[0]  = Q;
    assign LED[15] = QN;
    assign LED[14:1] = 14'b0;
endmodule
