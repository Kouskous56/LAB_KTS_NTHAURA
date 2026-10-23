`timescale 1ns/1ps
// 74153 - Dual 4-to-1 multiplexer (active-low strobes)
module ic_74153 (
    input  logic [3:0] d0, d1,   // data inputs (per mux)
    input  logic [1:0] s,
    input  logic       g0_n, g1_n,
    output logic       y0, y1
);
    always @(*) begin
        y0 = g0_n ? 1'b0 : d0[s];
        y1 = g1_n ? 1'b0 : d1[s];
    end
endmodule
