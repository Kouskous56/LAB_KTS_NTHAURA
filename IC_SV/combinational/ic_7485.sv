`timescale 1ns/1ps
// 7485 - 4-bit magnitude comparator
// cascading inputs: a_gt_b_in, a_eq_b_in, a_lt_b_in (active high chain)
module ic_7485 (
    input  logic [3:0] a, b,
    input  logic       a_gt_b_in, a_eq_b_in, a_lt_b_in,
    output logic       a_gt_b, a_eq_b, a_lt_b
);
    always @(*) begin
        if (a > b) begin a_gt_b=1; a_eq_b=0; a_lt_b=0; end
        else if (a < b) begin a_gt_b=0; a_eq_b=0; a_lt_b=1; end
        else begin // a == b: use cascading inputs
            a_gt_b = a_gt_b_in;
            a_eq_b = a_eq_b_in;
            a_lt_b = a_lt_b_in;
        end
    end
endmodule
