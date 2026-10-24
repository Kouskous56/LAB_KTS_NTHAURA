`timescale 1ns/1ps
// 1-to-2 Demultiplexer: routes input d to y0 or y1 based on sel
module demux1to2 (
    input  logic d, sel,
    output logic y0, y1
);
    assign y0 = (sel == 1'b0) ? d : 1'b0;
    assign y1 = (sel == 1'b1) ? d : 1'b0;
endmodule
