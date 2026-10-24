`timescale 1ns/1ps
// Implement f(x,y,z) = Sigma(2,3,5,7) using 8-to-1 MUX
// Data inputs: D0=0,D1=0,D2=1,D3=1,D4=0,D5=1,D6=0,D7=1
// D7..D0 = 10100110
module mux_function (
    input  logic x, y, z,
    output logic f
);
    logic [7:0] d = 8'b10101100;
    assign f = d[{x, y, z}];
endmodule
