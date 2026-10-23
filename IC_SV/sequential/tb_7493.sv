`timescale 1ns/1ps
module tb_7493;
    logic clk=0; logic r0_1=0, r0_2=0; logic [3:0] q;
    ic_7493 u(.clk(clk),.r0_1(r0_1),.r0_2(r0_2),.q(q));
    int bad=0;
    task automatic clkp(); clk=0; #5; clk=1; #5; clk=0; #5; endtask
    initial begin
        if (q !== 4'd0) begin bad++; $display("FAIL init"); end
        for (int i=0;i<15;i++) clkp();
        if (q !== 4'd15) begin bad++; $display("FAIL count: %0d", q); end
        clkp(); if (q !== 4'd0) begin bad++; $display("FAIL wrap"); end
        // reset
        r0_1=1; r0_2=1; #2; if (q !== 4'd0) begin bad++; $display("FAIL reset"); end
        r0_1=0; r0_2=0;
        if (bad==0) $display("7493 ALL TESTS PASS"); else $display("7493 FAIL: %0d", bad);
    end
endmodule
