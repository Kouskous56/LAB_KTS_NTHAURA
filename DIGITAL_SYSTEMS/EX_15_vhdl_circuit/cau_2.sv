`timescale 1ns/1ps
// Cau 2: Combinational circuit from VHDL
// s_temp = x[3] XOR x[2]
// b_temp = NOT(x[2]) AND x[2] AND x[2] = 0 (always)
// y = (s_temp==0) ? x[2:0] : b_temp
//   = x[2:0] when x[3]==x[2], else 0
module cau_2 (
    input  logic [3:0] x,
    output logic [2:0] y,
    output logic       s_temp,   // intermediate signal
    output logic [2:0] b_temp    // intermediate signal
);
    assign s_temp = x[3] ^ x[2];
    assign b_temp = (~x[2]) & x[2] & x[2];  // = 0 always
    // mux2to1
    assign y = (s_temp == 1'b0) ? x[2:0] : b_temp;
endmodule
