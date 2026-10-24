`timescale 1ns/1ps
// 4-bit up/down counter with enable and async reset
module counter_ud (
    input  logic clk, rst, en, up,
    output logic [3:0] count
);
    initial count = 4'b0;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) count <= 4'b0;
        else if (en) begin
            if (up) count <= count + 4'd1;
            else    count <= count - 4'd1;
        end
    end
endmodule
