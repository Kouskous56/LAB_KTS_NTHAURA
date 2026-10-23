`timescale 1ns/1ps
// Nexys A7 top: SW[2]=A, SW[1]=B, SW[0]=Ci ; LED[0]=S, LED[15]=Co
module top_module (
    input  logic [2:0]  SW,
    output logic [15:0] LED
);
    logic s, co;
    FA_ex1 u (.a(SW[2]), .b(SW[1]), .ci(SW[0]), .s(s), .co(co));
    assign LED[0]    = s;
    assign LED[15]   = co;
    assign LED[14:1] = 14'b0;
endmodule
