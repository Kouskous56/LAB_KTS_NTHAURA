`timescale 1ns/1ps
// 7430 - 8-input NAND gate
module ic_7430 (input logic a,b,c,d,e,f,g,h, output logic y);
    assign y = ~(a & b & c & d & e & f & g & h);
endmodule
