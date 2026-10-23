`timescale 1ns/1ps
// 74244 - Octal buffer/line driver (active-low OE, two 4-bit groups)
module ic_74244 (
    input  logic [7:0] a,
    input  logic       oe1_n, oe2_n,
    output tri [7:0]   y
);
    assign y[3:0] = oe1_n ? 4'bz : a[3:0];
    assign y[7:4] = oe2_n ? 4'bz : a[7:4];
endmodule
