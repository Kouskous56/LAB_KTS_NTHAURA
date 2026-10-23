`timescale 1ns/1ps
// 7411 - Triple 3-input AND gate
module ic_7411 (input logic [2:0] a, b, c, output logic [2:0] y);
    assign y = a & b & c;
endmodule
