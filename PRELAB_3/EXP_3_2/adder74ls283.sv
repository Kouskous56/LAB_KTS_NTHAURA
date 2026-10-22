`timescale 1ns/1ps
// 74LS283: 4-bit binary full adder with fast carry
// Pinout (TI SN74LS283, DIP-16) - khop 100% voi Figure 3.2 cua manual:
//   1=Sigma2  2=B2  3=A2  4=Sigma1  5=A1  6=B1  7=C0(carry-in)
//   8=GND     9=C4(carry-out) 10=Sigma4 11=B4 12=A4 13=Sigma3 14=A3 15=B3 16=VCC
// Chuc nang: S = A + B + C0 ; C4 = carry ra
// Luu y: TI mo ta '283 co FULL INTERNAL LOOK-AHEAD qua 4 bit
// (hieu ung tuong duong ripple o muc he thong) - xem LAB_3/IC_REFERENCE.md
module adder74ls283 (
    input  logic [3:0] A, B,
    input  logic       Cin,   // C0
    output logic [3:0] S,     // Sigma1..Sigma4
    output logic       Cout   // C4
);
    logic [4:0] sum;
    assign sum  = A + B + Cin;
    assign S    = sum[3:0];
    assign Cout = sum[4];
endmodule
