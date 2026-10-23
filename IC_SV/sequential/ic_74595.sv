`timescale 1ns/1ps
// 74595 - 8-bit serial-in parallel-out shift register with output latch
module ic_74595 (
    input  logic       clk, rclk, oe_n, srclr_n, ser,
    output logic [7:0] q
);
    logic [7:0] shift_reg, latch;
    always @(posedge clk or negedge srclr_n) begin
        if (!srclr_n) shift_reg <= 8'b0;
        else shift_reg <= {shift_reg[6:0], ser};
    end
    always @(posedge rclk) latch <= shift_reg;
    assign q = oe_n ? 8'bz : latch;
endmodule
