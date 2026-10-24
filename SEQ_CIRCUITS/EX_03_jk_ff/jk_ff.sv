`timescale 1ns/1ps
// JK Flip-Flop: negative edge triggered, with async clear
module jk_ff (
    input  logic clk_n, clr_n, j, k,
    output logic q, q_n
);
    always_ff @(negedge clk_n or negedge clr_n) begin
        if (!clr_n) begin q <= 0; q_n <= 1; end
        else begin
            case ({j,k})
                2'b00: begin end          // hold
                2'b01: begin q <= 0; q_n <= 1; end  // reset
                2'b10: begin q <= 1; q_n <= 0; end  // set
                2'b11: begin q <= ~q; q_n <= ~q_n; end  // toggle
            endcase
        end
    end
endmodule
