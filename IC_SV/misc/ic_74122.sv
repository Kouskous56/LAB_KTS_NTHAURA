`timescale 1ns/1ps
// 74122 - Retriggerable monostable multivibrator (simplified)
module ic_74122 (
    input  logic a1_n, a2_n, b1, b2,
    input  logic clr_n,
    output logic q, q_n
);
    logic trigger;
    assign trigger = ((!a1_n && !a2_n) || (b1 && b2)) && clr_n;
    always @(posedge trigger) begin
        if (clr_n) begin
            q <= 1'b1; q_n <= 1'b0;
            #100;
            q <= 1'b0; q_n <= 1'b1;
        end
    end
    always @(negedge clr_n) begin q <= 1'b0; q_n <= 1'b1; end
    initial begin q = 1'b0; q_n = 1'b1; end
endmodule
