`timescale 1ns/1ps
// 8-to-1 Multiplexer: y = d[sel]
module mux8to1 (
    input  logic [7:0] d,
    input  logic [2:0] sel,
    output logic y
);
    assign y = d[sel];
endmodule
