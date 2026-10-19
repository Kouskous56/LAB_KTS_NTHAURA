`timescale 1ns/1ps
module top_module (
    input  logic [3:0] SW,
    output logic [3:0] LED
);
    xs3_to_bin u (.xs3(SW), .bin(LED));
endmodule
