`timescale 1ns/1ps
module tb;
    logic a,b,sel,y;
    mux2to1 u (.a(a),.b(b),.sel(sel),.y(y));
    int bad=0;
    initial begin
        for (int i=0;i<8;i++) begin
            {a,b,sel}=i[2:0]; #1;
            if (y !== (sel ? b : a)) begin bad++; $display("FAIL %0d", i); end
        end
        if (bad==0) $display("EX_01 ALL TESTS PASS"); else $display("EX_01 FAIL: %0d", bad);
    end
endmodule
