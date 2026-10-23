`timescale 1ns/1ps
// 74107 - Dual JK flip-flop with clear (negative edge triggered)
module ic_74107 (
    input  logic clk1_n, clr1_n, j1, k1,
    input  logic clk2_n, clr2_n, j2, k2,
    output logic q1, q1_n, q2, q2_n
);
    always @(negedge clk1_n or negedge clr1_n) begin
        if (!clr1_n) begin q1<=0; q1_n<=1; end
        else case ({j1,k1})
            2'b00: begin end
            2'b01: begin q1<=0; q1_n<=1; end
            2'b10: begin q1<=1; q1_n<=0; end
            2'b11: begin q1<=~q1; q1_n<=~q1_n; end
        endcase
    end
    always @(negedge clk2_n or negedge clr2_n) begin
        if (!clr2_n) begin q2<=0; q2_n<=1; end
        else case ({j2,k2})
            2'b00: begin end
            2'b01: begin q2<=0; q2_n<=1; end
            2'b10: begin q2<=1; q2_n<=0; end
            2'b11: begin q2<=~q2; q2_n<=~q2_n; end
        endcase
    end
endmodule
