`timescale 1ns/1ps
// 7483 - 4-bit binary full adder (with carry in/out)
module ic_7483 (
    input  logic [3:0] a, b,
    input  logic       c_in,
    output logic [3:0] sum,
    output logic       c_out
);
    logic [4:0] r;
    assign r = {1'b0, a} + {1'b0, b} + c_in;
    assign sum = r[3:0];
    assign c_out = r[4];
endmodule
