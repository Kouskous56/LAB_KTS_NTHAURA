`timescale 1ns/1ps
module tb_7430;
    logic a,b,c,d,e,f,g,h,y; ic_7430 u(.a(a),.b(b),.c(c),.d(d),.e(e),.f(f),.g(g),.h(h),.y(y));
    int bad=0;
    initial begin
        for (int i=0;i<256;i++) begin {a,b,c,d,e,f,g,h}=i[7:0]; #1; if (y !== ~(a&b&c&d&e&f&g&h)) begin bad++; if(bad<=5)$display("FAIL"); end end
        if (bad==0) $display("7430 ALL TESTS PASS"); else $display("7430 FAIL: %0d", bad);
    end
endmodule
