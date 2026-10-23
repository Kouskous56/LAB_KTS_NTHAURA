`timescale 1ns/1ps
// 7404 - Hex inverter
module ic_7404 (input logic [5:0] a, output logic [5:0] y);
    assign y = ~a;
endmodule
