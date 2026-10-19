`timescale 1ns/1ps
// EX_3-10: 2-decade BCD -> 7-bit natural binary using 7483 only
// binary = 10*tens + units = (8+2)*tens + units
// Stage1: p = units + 2*tens  (5 bits)
// Stage2: bin = p + 8*tens     (7 bits)
module bcd2bin (
    input  logic [7:0] bcd,    // {tens[3:0], units[3:0]}
    output logic [6:0] bin
);
    logic [3:0] t, u;
    assign t = bcd[7:4];
    assign u = bcd[3:0];

    // Stage 1
    logic [3:0] s1;
    logic       c1;
    adder7483 a1 (.A(u), .B({t[2],t[1],t[0],1'b0}), .Cin(1'b0),
                  .S(s1), .Cout(c1));
    logic [4:0] p;
    assign p = {t[3] | c1, s1};          // bit4 = t[3] + c1 (never both 1)

    // Stage 2: low nibble bits 3..0 = p[3:0] + 8*tens[3:0] (T0 at bit3)
    logic [3:0] slo;
    logic       c2;
    adder7483 a2 (.A(p[3:0]), .B({t[0],1'b0,1'b0,1'b0}), .Cin(1'b0),
                  .S(slo), .Cout(c2));

    // high nibble bits 6..3 (bit3 is carry from low nibble)
    logic [3:0] shi;
    logic       c3;
    adder7483 a3 (.A({1'b0,1'b0,1'b0,p[4]}), .B({1'b0,t[3],t[2],t[1]}), .Cin(c2),
                  .S(shi), .Cout(c3));

    assign bin = {shi[2:0], slo};   // bits 6..4 = shi[2..0], bits 3..0 = slo
endmodule
