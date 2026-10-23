`timescale 1ns/1ps
// 7475 - Quad D latch (transparent when enable high)
module ic_7475 (
    input  logic [3:0] d,
    input  logic       en,
    output logic [3:0] q,
    output logic [3:0] q_n
);
    always @(*) begin
        if (en) begin q = d; q_n = ~d; end
    end
endmodule
