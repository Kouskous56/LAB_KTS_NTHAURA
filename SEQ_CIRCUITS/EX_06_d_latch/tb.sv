`timescale 1ns/1ps
module tb;
    logic d=0, en=0; logic q, q_n;
    d_latch u (.d(d),.en(en),.q(q),.q_n(q_n));
    int bad=0;
    initial begin
        en=1; d=1; #5; if (q!==1) begin bad++; $display("FAIL transparent"); end
        d=0; #5; if (q!==0) begin bad++; $display("FAIL transparent2"); end
        en=0; d=1; #5; if (q!==0) begin bad++; $display("FAIL hold"); end
        if (q_n !== ~q) begin bad++; $display("FAIL q_n"); end
        if (bad==0) $display("EX_06 ALL TESTS PASS"); else $display("EX_06 FAIL: %0d", bad);
    end
endmodule
