`timescale 1ns/1ps
// T Flip-Flop: toggle when T=1, hold when T=0
module t_ff (
    input  logic clk, rst, t,
    output logic q
);
    initial q = 0;
    always_ff @(posedge clk) begin
        if (rst) q <= 1'b0;
        else if (t) q <= ~q;
    end
endmodule
