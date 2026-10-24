`timescale 1ns/1ps
// Implement f(x,y,z) = Sigma(0,2,5,7) using 1-to-8 DEMUX
// f = OR of demux outputs at positions 0, 2, 5, 7
module demux_function (
    input  logic x, y, z,
    output logic f
);
    logic [7:0] yout;
    demux1to8 u (.d(1'b1), .sel({x, y, z}), .y(yout));
    assign f = yout[0] | yout[2] | yout[5] | yout[7];
endmodule
