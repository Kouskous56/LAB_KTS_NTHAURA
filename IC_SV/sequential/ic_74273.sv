`timescale 1ns/1ps
// 74273 - Octal D flip-flop (common clock and clear)
module ic_74273 (
    input  logic clk, clr_n,
    input  logic [7:0] d,
    output logic [7:0] q
);
    always @(posedge clk or negedge clr_n) begin
        if (!clr_n) q <= 8'b0;
        else q <= d;
    end
endmodule
