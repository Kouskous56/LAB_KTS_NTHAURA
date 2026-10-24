`timescale 1ns/1ps
module dec3to8 (
    input  logic [2:0] a,
    input  logic       en,
    output logic [7:0] y
);
    always_comb begin
        if (en) begin y = 8'b0; y[a] = 1'b1; end
        else y = 8'b0;
    end
endmodule
