`timescale 1ns/1ps
// 7474 - Dual D flip-flop with preset and clear (positive edge triggered)
module ic_7474 (
    input  logic clk1, pre1_n, clr1_n, d1,
    input  logic clk2, pre2_n, clr2_n, d2,
    output logic q1, q1_n,
    output logic q2, q2_n
);
    always @(posedge clk1 or negedge pre1_n or negedge clr1_n) begin
        if (!pre1_n) begin q1 <= 1'b1; q1_n <= 1'b0; end
        else if (!clr1_n) begin q1 <= 1'b0; q1_n <= 1'b1; end
        else begin q1 <= d1; q1_n <= ~d1; end
    end
    always @(posedge clk2 or negedge pre2_n or negedge clr2_n) begin
        if (!pre2_n) begin q2 <= 1'b1; q2_n <= 1'b0; end
        else if (!clr2_n) begin q2 <= 1'b0; q2_n <= 1'b1; end
        else begin q2 <= d2; q2_n <= ~d2; end
    end
endmodule
