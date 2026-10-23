`timescale 1ns/1ps
// LAB 4 - Experiment 4: 4-bit up counter 5 -> 14
module up_counter_5to14 (
    input  logic clk,
    input  logic rst,
    output logic [3:0] count
);
    always @(posedge clk) begin
        if (rst) count <= 4'd5;
        else     count <= (count == 4'd14) ? 4'd5 : (count + 4'd1);
    end
endmodule
