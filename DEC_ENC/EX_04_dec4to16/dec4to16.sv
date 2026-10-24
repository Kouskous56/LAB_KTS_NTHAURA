`timescale 1ns/1ps
// 4-to-16 Decoder: active-high outputs, with enable
module dec4to16 (
    input  logic [3:0] a,
    input  logic       en,
    output logic [15:0] y
);
    always_comb begin
        if (en) begin
            y = 16'b0;
            y[a] = 1'b1;
        end else begin
            y = 16'b0;
        end
    end
endmodule
