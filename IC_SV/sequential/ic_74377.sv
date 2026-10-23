`timescale 1ns/1ps
// 74377 - Octal D register with clock enable (active low CE)
module ic_74377 (
    input  logic clk, ce_n,
    input  logic [7:0] d,
    output logic [7:0] q
);
    always @(posedge clk) begin
        if (!ce_n) q <= d;
    end
endmodule
