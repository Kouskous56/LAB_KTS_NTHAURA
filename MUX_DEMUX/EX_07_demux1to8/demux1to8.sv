`timescale 1ns/1ps
// 1-to-8 Demultiplexer: routes input d to y[sel]
module demux1to8 (
    input  logic d,
    input  logic [2:0] sel,
    output logic [7:0] y
);
    always_comb begin
        y = 8'b0;
        y[sel] = d;
    end
endmodule
