`timescale 1ns/1ps
// D Flip-Flop with enable (positive edge, sync reset)
module dff_enable (
    input  logic clk, rst, en, d,
    output logic q
);
    initial q = 0;
    always_ff @(posedge clk) begin
        if (rst) q <= 1'b0;
        else if (en) q <= d;
    end
endmodule
