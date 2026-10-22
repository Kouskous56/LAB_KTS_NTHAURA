`timescale 1ns/1ps
// 74LS283: 4-bit adder, S = A + B + C0, C4 = carry out
// Pins (TI SN74LS283): 1=S2 2=B2 3=A2 4=S1 5=A1 6=B1 7=C0 8=GND
//                     9=C4 10=S4 11=B4 12=A4 13=S3 14=A3 15=B3 16=VCC
module adder74ls283 (
    input  logic [3:0] A, B,
    input  logic       Cin,
    output logic [3:0] S,
    output logic       Cout
);
    logic [4:0] sum;
    assign sum  = A + B + Cin;
    assign S    = sum[3:0];
    assign Cout = sum[4];
endmodule
