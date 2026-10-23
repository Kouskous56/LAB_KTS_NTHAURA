`timescale 1ns/1ps
// 74121 - Monostable multivibrator (simplified: outputs pulse of fixed width on trigger)
// A1,A2 (active low), B (active high) trigger inputs; Q (pulse), Q_n (complement)
module ic_74121 (
    input  logic a1_n, a2_n, b,
    output logic q, q_n
);
    // simplified: trigger when (a1_n & a2_n) low-pulse or b high-pulse
    logic trigger;
    assign trigger = (!a1_n && !a2_n) || (b && a1_n && a2_n);
    // one-shot: Q goes high for a fixed time on trigger rising edge
    always @(posedge trigger) begin
        q <= 1'b1; q_n <= 1'b0;
        #100;
        q <= 1'b0; q_n <= 1'b1;
    end
    initial begin q = 1'b0; q_n = 1'b1; end
endmodule
