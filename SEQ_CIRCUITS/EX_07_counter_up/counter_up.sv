`timescale 1ns/1ps
// 4-bit up counter with enable and async reset
module counter_up (
    input  logic clk, rst, en,
    output logic [3:0] count
);
    initial count = 4'b0;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) count <= 4'b0;
        else if (en) count <= count + 4'd1;
    end
endmodule
