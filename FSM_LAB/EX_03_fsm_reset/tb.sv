`timescale 1ns/1ps
module tb;
    logic clk=0, rst_async=0, en=1, x=0, z;
    fsm_reset u (.clk(clk),.rst_async(rst_async),.en(en),.x(x),.z(z));
    int bad=0;
    initial begin
        // async reset
        rst_async=1; #5; if (z !== 0) begin bad++; $display("FAIL reset"); end
        rst_async=0; #5;
        // enable=0: no state change
        x=1; clk=0; #5; clk=1; #5; clk=0; #5;
        if (z !== 0) begin bad++; $display("FAIL no-enable"); end
        // enable=1: capture
        en=1; clk=0; #5; clk=1; #5; clk=0; #5;
        if (z !== 1) begin bad++; $display("FAIL enable capture"); end
        if (bad==0) $display("EX_03 ALL TESTS PASS"); else $display("EX_03 FAIL: %0d", bad);
    end
endmodule
