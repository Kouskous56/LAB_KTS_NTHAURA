`timescale 1ns/1ps
module tb_74238;
    logic [2:0] a; logic g1,g2a_n,g2b_n; logic [7:0] y;
    ic_74238 u(.a(a),.g1(g1),.g2a_n(g2a_n),.g2b_n(g2b_n),.y(y));
    int bad=0;
    initial begin
        g1=1; g2a_n=0; g2b_n=0;
        for (int i=0;i<8;i++) begin a=i[2:0]; #1; if (y !== (8'b1<<a)) begin bad++; if(bad<=5)$display("FAIL a=%0d",a); end end
        g1=0; a=3'd0; #1; if (y !== 8'b0) begin bad++; $display("FAIL dis"); end
        if (bad==0) $display("74238 ALL TESTS PASS"); else $display("74238 FAIL: %0d", bad);
    end
endmodule
