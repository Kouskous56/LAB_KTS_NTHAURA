`timescale 1ns/1ps
module top_module (
    input  logic [7:0] SW,
    output logic [6:0] LED
);
    bcd2bin u (.bcd(SW), .bin(LED));
endmodule
