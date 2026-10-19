`timescale 1ns/1ps
// 74LS151: 8-to-1 multiplexer with active-low enable
module mux74ls151 (
    input  logic        E,      // enable, active low
    input  logic [2:0]  S,      // select {x,y,z} (MSB..LSB)
    input  logic [7:0]  I,      // data inputs I0..I7
    output logic        Y,      // output
    output logic        Ybar    // complemented output
);
    always_comb begin
        if (E) begin
            Y    = 1'b0;
            Ybar = 1'b1;
        end else begin
            Y    = I[S];
            Ybar = ~Y;
        end
    end
endmodule
