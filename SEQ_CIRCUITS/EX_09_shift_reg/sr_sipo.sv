`timescale 1ns/1ps
// 8-bit Shift Register: Serial In, Parallel Out (SIPO)
module sr_sipo (
    input  logic clk, rst, si,
    output logic [7:0] q
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) q <= 8'b0;
        else q <= {q[6:0], si};
    end
endmodule
