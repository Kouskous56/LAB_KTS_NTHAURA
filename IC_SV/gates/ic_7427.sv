`timescale 1ns/1ps
// 7427 - Triple 3-input NOR gate
module ic_7427 (input logic [2:0] a, b, c, output logic [2:0] y);
    assign y = ~(a | b | c);
endmodule
