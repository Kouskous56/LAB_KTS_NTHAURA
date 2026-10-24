`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1, t=0, q;
    t_ff u (.clk(clk),.rst(rst),.t(t),.q(q));
    int bad=0;
    initial begin
        rst=1; #10; rst=0; #5;
        // T=0: hold
        t=0; clk=0; #5; clk=1; #5; clk=0;
        if (q !== 0) begin bad++; $display("FAIL hold"); end
        // T=1: toggle
        t=1; clk=1; #5; clk=0;
        if (q !== 1) begin bad++; $display("FAIL toggle1"); end
        clk=1; #5; clk=0;
        if (q !== 0) begin bad++; $display("FAIL toggle2"); end
        // Frequency divider: T=1 divides clock by 2
        if (bad==0) $display("EX_04 ALL TESTS PASS"); else $display("EX_04 FAIL: %0d", bad);
    end
endmodule
