`timescale 1ns/1ps
module tb;
    logic x,y,z,f;
    dec_function u (.x(x),.y(y),.z(z),.f(f));
    int bad=0;
    logic exp_tab [0:7] = '{1,0,1,0,0,1,0,1};
    initial begin
        for (int i=0;i<8;i++) begin {x,y,z}=i[2:0]; #1; if (f !== exp_tab[i]) begin bad++; $display("FAIL %0d", i); end end
        if (bad==0) $display("EX_05 ALL TESTS PASS"); else $display("EX_05 FAIL: %0d", bad);
    end
endmodule
