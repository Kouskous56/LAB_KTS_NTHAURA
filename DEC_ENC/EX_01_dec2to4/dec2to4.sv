`timescale 1ns/1ps
// 2-to-4 Decoder: active-high outputs, y = 1 << a
module dec2to4 (
    input  logic [1:0] a,
    output logic [3:0] y
);
    always_comb begin
        y = 4'b0;
        y[a] = 1'b1;
    end
endmodule
