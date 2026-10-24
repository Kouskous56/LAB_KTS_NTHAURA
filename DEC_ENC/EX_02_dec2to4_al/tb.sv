`timescale 1ns/1ps
module tb;
    logic [1:0] a; logic g_n; logic [3:0] y_n;
    dec2to4_al u (.a(a),.g_n(g_n),.y_n(y_n));
    int bad=0;
    initial begin
        g_n = 0;
        for (int i=0;i<4;i++) begin a=i[1:0]; #1; if (y_n !== ~(4'b1<<a)) begin bad++; $display("FAIL a=%0d", a); end end
        g_n = 1; a=2'd0; #1;
        if (y_n !== 4'b1111) begin bad++; $display("FAIL disable"); end
        if (bad==0) $display("EX_02 ALL TESTS PASS"); else $display("EX_02 FAIL: %0d", bad);
    end
endmodule
