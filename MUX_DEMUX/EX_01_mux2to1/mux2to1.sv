`timescale 1ns/1ps
// 2-to-1 Multiplexer: y = sel ? b : a
module mux2to1 (
    input  logic a, b, sel,
    output logic y
);
    assign y = sel ? b : a;
endmodule
