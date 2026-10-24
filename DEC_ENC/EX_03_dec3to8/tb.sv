`timescale 1ns/1ps
module tb;
    logic [2:0] a; logic g1,g2a_n,g2b_n; logic [7:0] y_n;
    dec3to8 u (.a(a),.g1(g1),.g2a_n(g2a_n),.g2b_n(g2b_n),.y_n(y_n));
    int bad=0;
    initial begin
        g1=1; g2a_n=0; g2b_n=0;
        for (int i=0;i<8;i++) begin a=i[2:0]; #1; if (y_n !== ~(8'b1<<a)) begin bad++; $display("FAIL a=%0d", a); end end
        // disabled
        g1=0; a=3'd0; #1; if (y_n !== 8'hFF) begin bad++; $display("FAIL disable"); end
        if (bad==0) $display("EX_03 ALL TESTS PASS"); else $display("EX_03 FAIL: %0d", bad);
    end
endmodule
