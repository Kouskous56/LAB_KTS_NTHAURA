`timescale 1ns/1ps
// Part a): NOT, AND, OR, XOR from 2-input NAND gates
// Part b): XOR structural description using nand_2 component

// NOT from NAND: NOT(x) = NAND(x, x)
module not_from_nand (
    input  logic x,
    output logic z
);
    nand_2 u0 (.u(x), .v(x), .t(z));
endmodule

// AND from NAND: AND(x,y) = NAND(NAND(x,y), NAND(x,y))
module and_from_nand (
    input  logic x, y,
    output logic z
);
    logic n;
    nand_2 u0 (.u(x), .v(y), .t(n));
    nand_2 u1 (.u(n), .v(n), .t(z));
endmodule

// OR from NAND: OR(x,y) = NAND(NAND(x,x), NAND(y,y))
module or_from_nand (
    input  logic x, y,
    output logic z
);
    logic nx, ny;
    nand_2 u0 (.u(x), .v(x), .t(nx));  // NOT x
    nand_2 u1 (.u(y), .v(y), .t(ny));  // NOT y
    nand_2 u2 (.u(nx), .v(ny), .t(z)); // NAND(NOT x, NOT y) = x OR y
endmodule

// XOR from NAND: XOR(x,y) = NAND(NAND(x, NAND(x,y)), NAND(y, NAND(x,y)))
module xor_from_nand (
    input  logic x, y,
    output logic z
);
    logic n;   // NAND(x, y)
    logic a;   // NAND(x, n)
    logic b;   // NAND(y, n)
    nand_2 u0 (.u(x), .v(y), .t(n));
    nand_2 u1 (.u(x), .v(n), .t(a));
    nand_2 u2 (.u(y), .v(n), .t(b));
    nand_2 u3 (.u(a), .v(b), .t(z));
endmodule
