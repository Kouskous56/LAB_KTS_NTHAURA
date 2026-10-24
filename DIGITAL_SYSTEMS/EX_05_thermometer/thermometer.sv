`timescale 1ns/1ps
// Digital Thermometer: read temperature, compare with threshold, alarm
module thermometer (
    input  logic clk, rst,
    input  logic [7:0] temp_raw,   // raw temperature (0-255)
    input  logic [7:0] threshold,  // alarm threshold
    output logic [7:0] temp_display,
    output logic       alarm
);
    // Simple: display raw temp, alarm if temp > threshold
    assign temp_display = temp_raw;
    assign alarm = (temp_raw > threshold) ? 1'b1 : 1'b0;
endmodule
