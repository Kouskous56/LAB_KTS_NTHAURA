`timescale 1ns/1ps
// LAB 4 - Experiment 3: 3-bit down counter (0->7->6->...->0)
module down_counter_3bit (
    input  logic clk,
    input  logic rst,
    output logic [2:0] count
);
    always @(posedge clk) begin
        if (rst) count <= 3'd0;
        else     count <= (count == 3'd0) ? 3'd7 : (count - 3'd1);
    end
endmodule
