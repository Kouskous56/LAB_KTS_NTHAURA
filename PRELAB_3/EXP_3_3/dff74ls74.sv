`timescale 1ns/1ps
// 74LS74 model: D flip-flop, rising-edge triggered, asynchronous PRE/CLR (active low)
//   PRE=0 -> Q=1 (preset dominates), CLR=0 -> Q=0
//   otherwise Q <= D on the rising edge of CLK
// The async inputs are modelled as level-sensitive overrides on the outputs
// (matches the 74LS74 function table used in Table 3.5 of the lab manual).
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
    assign Q  = (!PRE) ? 1'b1 : (!CLR) ? 1'b0 : q;
    assign QN = ~Q;
endmodule
