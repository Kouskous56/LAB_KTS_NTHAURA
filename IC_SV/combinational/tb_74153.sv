`timescale 1ns/1ps
module tb_74153;
    logic [3:0] d0,d1; logic [1:0] s; logic g0_n,g1_n,y0,y1;
    ic_74153 u(.d0(d0),.d1(d1),.s(s),.g0_n(g0_n),.g1_n(g1_n),.y0(y0),.y1(y1));
    int bad=0;
    initial begin
        d0=4'b1010; d1=4'b0101; g0_n=0; g1_n=0;
        for (int i=0;i<4;i++) begin s=i[1:0]; #1;
            if (y0 !== d0[s] || y1 !== d1[s]) begin bad++; if(bad<=5)$display("FAIL s=%0d",s); end
        end
        g0_n=1; g1_n=1; s=2'd0; #1;
        if (y0!==0 || y1!==0) begin bad++; $display("FAIL dis"); end
        if (bad==0) $display("74153 ALL TESTS PASS"); else $display("74153 FAIL: %0d", bad);
    end
endmodule
