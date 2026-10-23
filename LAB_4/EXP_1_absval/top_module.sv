`timescale 1ns/1ps
// Nexys A7: SW[3:0]=A, LED[3:0]=S (absolute value)
module top_module (
    input  logic [3:0]  SW,
    output logic [15:0] LED
);
    logic [3:0] S;
    absval_4bit u (.A(SW[3:0]), .S(S));
    assign LED[3:0]  = S;
    assign LED[15:4] = 12'b0;
endmodule
