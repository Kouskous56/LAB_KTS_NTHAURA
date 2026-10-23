`timescale 1ns/1ps
module tb_7411;
    logic [2:0] a,b,c,y; ic_7411 u(.a(a),.b(b),.c(c),.y(y));
    int bad=0;
    initial begin
        for (int i=0;i<8;i++) for (int j=0;j<8;j++) for (int k=0;k<8;k++) begin a=i[2:0]; b=j[2:0]; c=k[2:0]; #1; if (y !== (a&b&c)) begin bad++; if(bad<=5)$display("FAIL"); end end
        if (bad==0) $display("7411 ALL TESTS PASS"); else $display("7411 FAIL: %0d", bad);
    end
endmodule
