`timescale 1ns/1ps
// D Flip-Flop: positive edge triggered, async reset
module dff_basic (
    input  logic clk, rst_n, d,
    output logic q, q_n
);
    initial begin q = 0; q_n = 1; end
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 1'b0;
            q_n <= 1'b1;
        end else begin
            q <= d;
            q_n <= ~d;
        end
    end
endmodule
