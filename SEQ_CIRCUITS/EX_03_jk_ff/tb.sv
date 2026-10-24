`timescale 1ns/1ps
module tb;
    logic clk_n=1, clr_n=1, j=0, k=0;
    logic q, q_n;
    jk_ff u (.clk_n(clk_n),.clr_n(clr_n),.j(j),.k(k),.q(q),.q_n(q_n));
    int bad=0;
    task automatic pulse(); clk_n=1; #5; clk_n=0; #5; clk_n=1; endtask
    initial begin
        clr_n=0; #2; clr_n=1; #2; if (q!==0) begin bad++; $display("FAIL clear"); end
        // J=1,K=0 -> set
        j=1; k=0; pulse(); if (q!==1) begin bad++; $display("FAIL set"); end
        // J=0,K=1 -> reset
        j=0; k=1; pulse(); if (q!==0) begin bad++; $display("FAIL reset"); end
        // J=1,K=1 -> toggle
        j=1; k=1; pulse(); if (q!==1) begin bad++; $display("FAIL toggle1"); end
        pulse(); if (q!==0) begin bad++; $display("FAIL toggle2"); end
        // J=0,K=0 -> hold
        j=0; k=0; pulse(); if (q!==0) begin bad++; $display("FAIL hold"); end
        if (bad==0) $display("EX_03 ALL TESTS PASS"); else $display("EX_03 FAIL: %0d", bad);
    end
endmodule
