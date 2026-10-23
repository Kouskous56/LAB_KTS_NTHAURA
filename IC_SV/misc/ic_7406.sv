`timescale 1ns/1ps
// 7406 - Hex inverter (open-collector, high-voltage outputs) - modeled as inverter
module ic_7406 (input logic [5:0] a, output logic [5:0] y);
    assign y = ~a;
endmodule
