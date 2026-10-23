`timescale 1ns/1ps
// 7493 - 4-bit binary ripple counter (with reset R0(1),R0(2))
module ic_7493 (
    input  logic clk, r0_1, r0_2,
    output logic [3:0] q
);
    initial q = 4'b0;
    always @(posedge clk or posedge r0_1 or posedge r0_2) begin
        if (r0_1 && r0_2) q <= 4'b0;
        else q <= q + 4'd1;
    end
endmodule
