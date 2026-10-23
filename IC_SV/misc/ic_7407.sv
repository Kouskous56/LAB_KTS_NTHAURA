`timescale 1ns/1ps
// 7407 - Hex buffer (open-collector, high-voltage outputs) - modeled as buffer
module ic_7407 (input logic [5:0] a, output logic [5:0] y);
    assign y = a;
endmodule
