`timescale 1ns/1ps
// 2-to-4 Decoder: active-low outputs, with enable (active low)
module dec2to4_al (
    input  logic [1:0] a,
    input  logic       g_n,     // enable, active low
    output logic [3:0] y_n      // active low outputs
);
    always_comb begin
        if (g_n) y_n = 4'b1111;
        else     y_n = ~(4'b1 << a);
    end
endmodule
