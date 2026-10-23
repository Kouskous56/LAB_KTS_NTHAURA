`timescale 1ns/1ps
// 7476 - Dual JK flip-flop (negative edge triggered, with preset/clear)
module ic_7476 (
    input  logic clk1_n, pre1_n, clr1_n, j1, k1,
    input  logic clk2_n, pre2_n, clr2_n, j2, k2,
    output logic q1, q1_n,
    output logic q2, q2_n
);
    always @(negedge clk1_n or negedge pre1_n or negedge clr1_n) begin
        if (!pre1_n) begin q1 <= 1'b1; q1_n <= 1'b0; end
        else if (!clr1_n) begin q1 <= 1'b0; q1_n <= 1'b1; end
        else begin
            case ({j1,k1})
                2'b00: begin end
                2'b01: begin q1 <= 1'b0; q1_n <= 1'b1; end
                2'b10: begin q1 <= 1'b1; q1_n <= 1'b0; end
                2'b11: begin q1 <= ~q1; q1_n <= ~q1_n; end
            endcase
        end
    end
    always @(negedge clk2_n or negedge pre2_n or negedge clr2_n) begin
        if (!pre2_n) begin q2 <= 1'b1; q2_n <= 1'b0; end
        else if (!clr2_n) begin q2 <= 1'b0; q2_n <= 1'b1; end
        else begin
            case ({j2,k2})
                2'b00: begin end
                2'b01: begin q2 <= 1'b0; q2_n <= 1'b1; end
                2'b10: begin q2 <= 1'b1; q2_n <= 1'b0; end
                2'b11: begin q2 <= ~q2; q2_n <= ~q2_n; end
            endcase
        end
    end
endmodule
