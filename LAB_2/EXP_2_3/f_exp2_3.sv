`timescale 1ns/1ps
// EXP_2_3: F = NOR(NOR(x, y&z), NAND(~y, x))  (as given in the schematic)
module f_exp2_3 (
    input  logic x, y, z,
    output logic F
);
    logic A, B;
    assign A = ~(x | (y & z));        // NOR(x, yz)
    assign B = ~((~y) & x);           // NAND(y', x)
    assign F = ~(A | B);              // NOR(A, B)
endmodule
