`timescale 1ns/1ps
// 74LS74 model: D flip-flop, rising-edge triggered, asynchronous PRE/CLR (active low)
// Datasheet (TI SN74LS74A) + Figure 3.5 of the lab manual:
//   PRE=0, CLR=1 -> Q=1, Q'=0   (preset, level-sensitive)
//   PRE=1, CLR=0 -> Q=0, Q'=1   (clear, level-sensitive)
//   PRE=0, CLR=0 -> Q=1, Q'=1   (NONSTABLE - undefined, see Note 1)
//   PRE=1, CLR=1 -> Q<=D on the rising edge of CLK, otherwise hold
// The async inputs act on the level (not only on the edge), so they are
// modelled as an override on the outputs.
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
