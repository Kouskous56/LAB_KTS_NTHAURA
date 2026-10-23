`timescale 1ns/1ps
// 74174 - Hex D flip-flop (common clock and clear)
module ic_74174 (
    input  logic clk, clr_n,
    input  logic [5:0] d,
    output logic [5:0] q
);
    always @(posedge clk or negedge clr_n) begin
        if (!clr_n) q <= 6'b0;
        else q <= d;
    end
endmodule
