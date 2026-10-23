`timescale 1ns/1ps
module tb_7420;
    logic [1:0] a,b,c,d,y; ic_7420 u(.a(a),.b(b),.c(c),.d(d),.y(y));
    int bad=0;
    initial begin
        for (int i=0;i<4;i++) for (int j=0;j<4;j++) for (int k=0;k<4;k++) for (int l=0;l<4;l++) begin a=i[1:0]; b=j[1:0]; c=k[1:0]; d=l[1:0]; #1; if (y !== ~(a&b&c&d)) begin bad++; if(bad<=5)$display("FAIL"); end end
        if (bad==0) $display("7420 ALL TESTS PASS"); else $display("7420 FAIL: %0d", bad);
    end
endmodule
