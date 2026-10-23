`timescale 1ns/1ps
// 74164 - 8-bit serial-in parallel-out shift register
module ic_74164 (
    input  logic clk, clr_n,
    input  logic a, b,   // serial inputs (ANDed internally)
    output logic [7:0] q
);
    logic si;
    assign si = a & b;
    always @(posedge clk or negedge clr_n) begin
        if (!clr_n) q <= 8'b0;
        else q <= {q[6:0], si};
    end
endmodule
