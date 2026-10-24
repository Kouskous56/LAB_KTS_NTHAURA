`timescale 1ns/1ps
// Counter 0 to 42 using 74393 (dual 4-bit binary counter) + logic
// 42 = 101010 (6 bits)
// Use 6 bits: Q5 Q4 Q3 Q2 Q1 Q0
// Counter1 (lower 4 bits): Q3 Q2 Q1 Q0
// Counter2 (upper 2 bits): Q5 Q4
// Reset when count == 42 (101010): Q5=1, Q4=0, Q3=1, Q2=0, Q1=1, Q0=0
module counter_0_42 (
    input  logic clk, rst,
    output logic [5:0] count,  // Q5 Q4 Q3 Q2 Q1 Q0
    output logic carry        // overflow (count==42)
);
    logic [5:0] cnt;
    logic reset_cond;

    // Reset condition: count == 42 (101010)
    assign reset_cond = cnt[5] & ~cnt[4] & cnt[3] & ~cnt[2] & cnt[1] & ~cnt[0];

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 6'd0;
        end else if (reset_cond) begin
            cnt <= 6'd0;
        end else begin
            cnt <= cnt + 6'd1;
        end
    end

    assign count = cnt;
    assign carry = reset_cond;
endmodule
