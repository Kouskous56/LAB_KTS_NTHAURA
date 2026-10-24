`timescale 1ns/1ps
module tb;
    logic x,y,z,f;
    func_exp5 u (.x(x),.y(y),.z(z),.f(f));
    int bad=0;
    logic exp_tab [0:7] = '{0,0,1,1,0,1,0,1};
    initial begin
        $dumpfile("wave.vcd"); $dumpvars(0, tb);
        for (int i=0;i<8;i++) begin
            {x,y,z}=i[2:0]; #1;
            if (f !== exp_tab[i]) begin bad++; $display("FAIL %0d", i); end
        end
        if (bad==0) $display("EXP_5 ALL TESTS PASS"); else $display("EXP_5 FAIL: %0d", bad);
    end
endmodule
