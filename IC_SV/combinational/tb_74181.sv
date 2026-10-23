`timescale 1ns/1ps
module tb_74181;
    logic [3:0] a,b,s,f; logic m,c_n,c_n4,aeb;
    ic_74181 u(.a(a),.b(b),.s(s),.m(m),.c_n(c_n),.f(f),.c_n4(c_n4),.aeb(aeb));
    int bad=0;
    initial begin
        // logic mode: XOR (s=6) with m=1
        m=1; s=4'h6; a=4'hA; b=4'h5; c_n=1; #1;
        if (f !== (a^b)) begin bad++; $display("FAIL xor"); end
        // arithmetic mode: add (s=9? use default add path) m=0
        m=0; s=4'h9; a=4'd5; b=4'd3; c_n=1; #1;
        if (f !== 4'd8) begin bad++; $display("FAIL add: f=%0d", f); end
        if (bad==0) $display("74181 ALL TESTS PASS"); else $display("74181 FAIL: %0d", bad);
    end
endmodule
