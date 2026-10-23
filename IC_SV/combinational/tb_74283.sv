`timescale 1ns/1ps
module tb_74283;
    logic [3:0] a,b,sum; logic c_in,c_out;
    ic_74283 u(.a(a),.b(b),.c_in(c_in),.sum(sum),.c_out(c_out));
    int bad=0;
    logic [4:0] exp;
    initial begin
        for (int ci=0;ci<2;ci++) for (int aa=0;aa<16;aa++) for (int bb=0;bb<16;bb++) begin
            a=aa[3:0]; b=bb[3:0]; c_in=ci[0]; #1;
            exp = {1'b0,a}+{1'b0,b}+c_in;
            if (sum !== exp[3:0] || c_out !== exp[4]) begin bad++; if(bad<=5)$display("FAIL"); end
        end
        if (bad==0) $display("74283 ALL TESTS PASS"); else $display("74283 FAIL: %0d", bad);
    end
endmodule
