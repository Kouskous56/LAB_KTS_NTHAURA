`timescale 1ns/1ps
module demux1to4 (input logic d, input logic [1:0] sel, output logic [3:0] y);
    always_comb begin
        y = 4'b0;
        y[sel] = d;
    end
endmodule
