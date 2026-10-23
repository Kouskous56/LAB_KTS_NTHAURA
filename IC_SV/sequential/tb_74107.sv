`timescale 1ns/1ps
module tb_74107;
    logic clk1_n=1, clr1_n=1, j1=0, k1=0;
    logic clk2_n=1, clr2_n=1, j2=0, k2=0;
    logic q1,q1_n,q2,q2_n;
    ic_74107 u(.clk1_n(clk1_n),.clr1_n(clr1_n),.j1(j1),.k1(k1),
               .clk2_n(clk2_n),.clr2_n(clr2_n),.j2(j2),.k2(k2),
               .q1(q1),.q1_n(q1_n),.q2(q2),.q2_n(q2_n));
    int bad=0;
    task automatic pulse1(); clk1_n=1; #5; clk1_n=0; #5; clk1_n=1; endtask
    initial begin
        clr1_n=0; #2; clr1_n=1; #2; if (q1!==0) begin bad++; $display("FAIL clear"); end
        j1=1; k1=0; pulse1(); if (q1!==1) begin bad++; $display("FAIL set"); end
        j1=0; k1=1; pulse1(); if (q1!==0) begin bad++; $display("FAIL reset"); end
        j1=1; k1=1; pulse1(); if (q1!==1) begin bad++; $display("FAIL toggle"); end
        if (bad==0) $display("74107 ALL TESTS PASS"); else $display("74107 FAIL: %0d", bad);
    end
endmodule
