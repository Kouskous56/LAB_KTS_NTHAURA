`timescale 1ns/1ps
// 74373 - Octal D latch with 3-state outputs (OE active low, LE latch enable)
module ic_74373 (
    input  logic [7:0] d,
    input  logic       le, oe_n,
    output tri [7:0]   q
);
    logic [7:0] latch;
    always @(*) begin
        if (le) latch = d;
    end
    assign q = oe_n ? 8'bz : latch;
endmodule
