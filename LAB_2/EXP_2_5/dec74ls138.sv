`timescale 1ns/1ps
// 74LS138: 3-to-8 decoder/demultiplexer with 3 enables
// enables: E1,E2 active low; E3 active high. outputs Y0..Y7 active low.
module dec74ls138 (
    input  logic        E1, E2, E3,   // enables
    input  logic [2:0]  A,            // select {A2,A1,A0}
    output logic [7:0]  Y             // active-low outputs
);
    logic enabled;
    assign enabled = (~E1) & (~E2) & E3;
    always_comb begin
        if (!enabled) Y = 8'hFF;
        else begin
            Y = 8'hFF;
            Y[A] = 1'b0;   // selected output goes low
        end
    end
endmodule
