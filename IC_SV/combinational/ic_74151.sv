`timescale 1ns/1ps
// 74151 - 8-to-1 multiplexer (active-low strobe G, outputs Y and W (complement))
module ic_74151 (
    input  logic [7:0] d,
    input  logic [2:0] s,
    input  logic       g_n,        // strobe, active low
    output logic       y,          // selected data
    output logic       w           // complement of y (when enabled)
);
    always @(*) begin
        if (g_n) begin y = 1'b0; w = 1'b1; end
        else begin y = d[s]; w = ~d[s]; end
    end
endmodule
