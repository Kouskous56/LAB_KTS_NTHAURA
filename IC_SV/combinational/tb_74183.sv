`timescale 1ns/1ps
module tb_74183;
    logic a1,b1,c1,a2,b2,c2,s1,co1,s2,co2;
    ic_74183 u(.a1(a1),.b1(b1),.c1(c1),.a2(a2),.b2(b2),.c2(c2),.s1(s1),.co1(co1),.s2(s2),.co2(co2));
    int bad=0;
    initial begin
        for (int i=0;i<8;i++) for (int j=0;j<8;j++) begin
            {a1,b1,c1}=i[2:0]; {a2,b2,c2}=j[2:0]; #1;
            if (s1 !== (a1^b1^c1) || co1 !== ((a1&b1)|(a1&c1)|(b1&c1))) begin bad++; if(bad<=5)$display("FAIL1"); end
            if (s2 !== (a2^b2^c2) || co2 !== ((a2&b2)|(a2&c2)|(b2&c2))) begin bad++; if(bad<=5)$display("FAIL2"); end
        end
        if (bad==0) $display("74183 ALL TESTS PASS"); else $display("74183 FAIL: %0d", bad);
    end
endmodule
