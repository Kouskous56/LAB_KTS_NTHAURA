`timescale 1ns/1ps
module tb;
    logic s=0, r=0; logic q, q_n;
    sr_latch u (.s(s),.r(r),.q(q),.q_n(q_n));
    int bad=0;
    initial begin
        // Set
        s=1; r=0; #5; if (q!==1) begin bad++; $display("FAIL set"); end
        // Hold
        s=0; r=0; #5; if (q!==1) begin bad++; $display("FAIL hold1"); end
        // Reset
        s=0; r=1; #5; if (q!==0) begin bad++; $display("FAIL reset"); end
        // Hold
        s=0; r=0; #5; if (q!==0) begin bad++; $display("FAIL hold2"); end
        if (bad==0) $display("EX_05 ALL TESTS PASS"); else $display("EX_05 FAIL: %0d", bad);
    end
endmodule
