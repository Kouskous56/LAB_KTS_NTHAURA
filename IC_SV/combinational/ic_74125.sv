`timescale 1ns/1ps
// 74125 - Quad tri-state buffer (active-low enable)
module ic_74125 (input logic [3:0] a, e_n, output tri [3:0] y);
    assign y = e_n ? 4'bz : a;
endmodule
