`timescale 1ns/1ps
// 7414 - Hex Schmitt-trigger inverter (modeled as inverter; hysteresis not simulated)
module ic_7414 (input logic [5:0] a, output logic [5:0] y);
    assign y = ~a;
endmodule
