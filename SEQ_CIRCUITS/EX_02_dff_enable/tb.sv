`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1, en=0, d=0, q;
    dff_enable u (.clk(clk),.rst(rst),.en(en),.d(d),.q(q));
    int bad=0;
    initial begin
        rst=1; #10; rst=0; #5;
        // en=0: no capture
        d=1; clk=0; #5; clk=1; #5; clk=0;
        if (q !== 0) begin bad++; $display("FAIL no-capture"); end
        // en=1: capture
        en=1; d=1; clk=1; #5; clk=0;
        if (q !== 1) begin bad++; $display("FAIL capture 1"); end
        d=0; clk=1; #5; clk=0;
        if (q !== 0) begin bad++; $display("FAIL capture 0"); end
        // reset overrides enable
        rst=1; en=1; d=1; clk=1; #5; clk=0;
        if (q !== 0) begin bad++; $display("FAIL reset"); end
        if (bad==0) $display("EX_02 ALL TESTS PASS"); else $display("EX_02 FAIL: %0d", bad);
    end
endmodule
