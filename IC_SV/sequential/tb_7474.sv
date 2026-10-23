`timescale 1ns/1ps
module tb_7474;
    logic clk1=0, pre1_n=1, clr1_n=1, d1=0;
    logic clk2=0, pre2_n=1, clr2_n=1, d2=0;
    logic q1,q1_n,q2,q2_n;
    ic_7474 u (.clk1(clk1),.pre1_n(pre1_n),.clr1_n(clr1_n),.d1(d1),
               .clk2(clk2),.pre2_n(pre2_n),.clr2_n(clr2_n),.d2(d2),
               .q1(q1),.q1_n(q1_n),.q2(q2),.q2_n(q2_n));
    int bad=0;
    task automatic clk1_pulse(); clk1=0; #5; clk1=1; #5; clk1=0; endtask
    initial begin
        // preset
        pre1_n=0; #2; if (q1!==1) begin bad++; $display("FAIL preset"); end; pre1_n=1; #2;
        // clear
        clr1_n=0; #2; if (q1!==0) begin bad++; $display("FAIL clear"); end; clr1_n=1; #2;
        // D capture on rising edge
        d1=1; clk1_pulse(); if (q1!==1) begin bad++; $display("FAIL D=1"); end
        d1=0; clk1_pulse(); if (q1!==0) begin bad++; $display("FAIL D=0"); end
        // complement output
        if (q1_n !== ~q1) begin bad++; $display("FAIL q_n"); end
        // second FF independent
        d2=1; clk2=0; #5; clk2=1; #5; clk2=0;
        if (q2!==1) begin bad++; $display("FAIL FF2"); end
        if (bad==0) $display("7474 ALL TESTS PASS"); else $display("7474 FAIL: %0d", bad);
    end
endmodule
