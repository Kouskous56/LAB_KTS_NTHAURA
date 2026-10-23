`timescale 1ns/1ps
// 74670 - 4x4 register file (4 words x 4 bits)
// Two read ports (RA, RB), one write port (WA), write enable (WE_n active low)
module ic_74670 (
    input  logic [1:0] wa, ra, rb,
    input  logic [3:0] din,
    input  logic       we_n,
    output logic [3:0] qa, qb
);
    logic [3:0] mem [0:3];
    always @(*) begin
        if (!we_n) mem[wa] = din;
    end
    assign qa = mem[ra];
    assign qb = mem[rb];
endmodule
