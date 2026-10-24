`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1, tick_1s=0;
    logic [1:0] ns, ew; logic [3:0] timer;
    traffic_4way u (.clk(clk),.rst(rst),.tick_1s(tick_1s),.ns(ns),.ew(ew),.timer(timer));
    int bad=0;
    task automatic tick(); tick_1s=1; @(posedge clk); #1; tick_1s=0; @(posedge clk); #1; endtask
    initial begin
        rst=1;
        for (int i=0;i<2;i++) begin clk=0; #5; clk=1; #5; clk=0; #5; end
        rst=0; #5;
        // NS Green
        if (ns !== 2'b01 || ew !== 2'b00) begin bad++; $display("FAIL init"); end
        // 5 ticks green
        tick(); tick(); tick(); tick(); tick();
        // NS Yellow
        if (ns !== 2'b10) begin bad++; $display("FAIL NS_Y"); end
        // 2 ticks yellow
        tick(); tick();
        // EW Green
        if (ew !== 2'b01) begin bad++; $display("FAIL EW_G"); end
        if (bad==0) $display("EX_08 ALL TESTS PASS"); else $display("EX_08 FAIL: %0d", bad);
        $finish;
    end
    always #5 clk = ~clk;
endmodule
