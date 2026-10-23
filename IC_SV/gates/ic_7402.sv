`timescale 1ns/1ps
// 7402 - Quad 2-input NOR gate
module ic_7402 (input logic [3:0] a, b, output logic [3:0] y);
    assign y = ~(a | b);
endmodule
