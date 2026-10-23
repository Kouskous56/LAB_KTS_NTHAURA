`timescale 1ns/1ps
// A=SW[3:0], B=SW[7:4], sel=SW[8] ; S=LED[3:0], Co=LED[4]
module top_module (
    input  logic [8:0]  SW,
    output logic [15:0] LED
);
    logic [3:0] S;
    logic       Co;
    addsub_4bit_m1 u (.A(SW[3:0]), .B(SW[7:4]), .sel(SW[8]), .S(S), .Co(Co));
    assign LED[3:0]  = S;
    assign LED[4]    = Co;
    assign LED[15:5] = 11'b0;
endmodule
