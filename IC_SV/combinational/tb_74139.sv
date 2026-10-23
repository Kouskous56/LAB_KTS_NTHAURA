`timescale 1ns/1ps
module tb_74139;
    logic [1:0] a0,a1; logic g0_n,g1_n; logic [3:0] y0_n,y1_n;
    ic_74139 u(.a0(a0),.a1(a1),.g0_n(g0_n),.g1_n(g1_n),.y0_n(y0_n),.y1_n(y1_n));
    int bad=0;
    initial begin
        g0_n=0; g1_n=0;
        for (int i=0;i<4;i++) for (int j=0;j<4;j++) begin a0=i[1:0]; a1=j[1:0]; #1;
            if (y0_n !== ~(4'b1<<a0) || y1_n !== ~(4'b1<<a1)) begin bad++; if(bad<=5)$display("FAIL"); end
        end
        if (bad==0) $display("74139 ALL TESTS PASS"); else $display("74139 FAIL: %0d", bad);
    end
endmodule
