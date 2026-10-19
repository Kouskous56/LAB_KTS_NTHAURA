`timescale 1ns/1ps
// EX_3-9: Excess-3 -> natural binary using one 7483
// xs3 = binary + 3  =>  binary = xs3 - 3 = xs3 + (-3)
// -3 in 4-bit two's complement = 1101, Cin = 0
module xs3_to_bin (
    input  logic [3:0] xs3,
    output logic [3:0] bin
);
    logic cout;
    adder7483 u (.A(xs3), .B(4'b1101), .Cin(1'b0), .S(bin), .Cout(cout));
endmodule
