`timescale 1ns/1ps
// Method 1: structural, 4 x FA_ex1. sel=0: A+B ; sel=1: A-B (two's complement)
module addsub_4bit_m1 (
    input  logic [3:0] A, B,
    input  logic       sel,
    output logic [3:0] S,
    output logic       Co
);
    logic [4:0] c;
    assign c[0] = sel;
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin : fa
            FA_ex1 u (.a(A[i]), .b(B[i] ^ sel), .ci(c[i]), .s(S[i]), .co(c[i+1]));
        end
    endgenerate
    assign Co = c[4];
endmodule
