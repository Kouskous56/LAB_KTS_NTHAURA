`timescale 1ns/1ps
// 74LS74: D flip-flop, rising-edge triggered, asynchronous PRE/CLR (active low)
// Pinout (TI SN74LS74A, DIP-14):
//   1=1CLR 2=1D 3=1CLK 4=1PRE 5=1Q 6=1Q' 7=GND
//   8=2Q'  9=2Q 10=2PRE 11=2CLK 12=2D 13=2CLR 14=VCC
// Function table (Figure 3.5 cua manual / TI datasheet):
//   PRE=0, CLR=1 -> Q=1, Q'=0   (preset, muc)
//   PRE=1, CLR=0 -> Q=0, Q'=1   (clear, muc)
//   PRE=0, CLR=0 -> Q=1, Q'=1   (NONSTABLE - undefined, Note 1)
//   PRE=1, CLR=1 -> Q<=D tren canh len cua CLK, nguoi lai giu nguyen
// PRE/CLR tac dong theo MUC (khong chi theo canh) - dung nhu TI:
// "A low level at the preset or clear inputs sets or resets the outputs
//  regardless of the levels of the other inputs."
module dff74ls74 (
    input  logic D, CLK, PRE, CLR,
    output logic Q, QN
);
    logic q;
    always_ff @(posedge CLK or negedge PRE or negedge CLR) begin
        if (!PRE)      q <= 1'b1;
        else if (!CLR) q <= 1'b0;
        else           q <= D;
    end
    // both PRE and CLR asserted -> nonstable (Q=1, Q'=1) per Note 1
    assign Q  = (!PRE && !CLR) ? 1'b1 : (!PRE) ? 1'b1 : (!CLR) ? 1'b0 : q;
    assign QN = (!PRE && !CLR) ? 1'b1 : (!PRE) ? 1'b0 : (!CLR) ? 1'b1 : ~q;
endmodule
