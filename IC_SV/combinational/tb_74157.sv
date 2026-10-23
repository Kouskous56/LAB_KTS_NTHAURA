`timescale 1ns/1ps
module tb_74157;
    logic [3:0] a,b,y; logic s,g_n;
    ic_74157 u(.a(a),.b(b),.s(s),.g_n(g_n),.y(y));
    int bad=0;
    initial begin
        a=4'b1010; b=4'b0101; g_n=0;
        s=0; #1; if (y !== a) begin bad++; $display("FAIL s=0"); end
        s=1; #1; if (y !== b) begin bad++; $display("FAIL s=1"); end
        g_n=1; #1; if (y !== 4'b0) begin bad++; $display("FAIL dis"); end
        if (bad==0) $display("74157 ALL TESTS PASS"); else $display("74157 FAIL: %0d", bad);
    end
endmodule
