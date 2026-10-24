`timescale 1ns/1ps
module tb;
    logic clk=0, rst_n=0, d=0;
    logic q, q_n;
    dff_basic u (.clk(clk), .rst_n(rst_n), .d(d), .q(q), .q_n(q_n));
    int bad=0;
    initial begin
        // reset
        rst_n=0; d=1; #10; rst_n=1; #5;
        if (q !== 0) begin bad++; $display("FAIL reset"); end
        // capture d=1 on rising edge
        d=1; clk=0; #5; clk=1; #5; clk=0;
        if (q !== 1) begin bad++; $display("FAIL capture 1"); end
        if (q_n !== ~q) begin bad++; $display("FAIL q_n"); end
        // capture d=0
        d=0; clk=1; #5; clk=0;
        if (q !== 0) begin bad++; $display("FAIL capture 0"); end
        // no change without clock edge
        d=1; #5; if (q !== 0) begin bad++; $display("FAIL no-clock-change"); end
        if (bad==0) $display("EX_01 ALL TESTS PASS"); else $display("EX_01 FAIL: %0d", bad);
    end
endmodule
