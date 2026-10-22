`timescale 1ns/1ps
// Nexys A7: SW[3:0]=A, SW[7:4]=B, SW[8]=Sel
//            LED[3:0]=S, LED[15]=Cout
module top_module (
    input  logic [8:0] SW,
    output logic [15:0] LED
);
    logic [3:0] S;
    logic Cout;
    full_addsub_4bit u (.Sel(SW[8]), .A(SW[3:0]), .B(SW[7:4]), .S(S), .Cout(Cout));
    assign LED[3:0]  = S;
    assign LED[15]   = Cout;
    assign LED[14:4] = 11'b0;
endmodule
