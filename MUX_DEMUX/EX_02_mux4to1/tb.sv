`timescale 1ns/1ps
module tb;
    logic [3:0] d; logic [1:0] sel; logic y;
    mux4to1 u (.d(d),.sel(sel),.y(y));
    int bad=0;
    initial begin
        d = 4'b1010;
        for (int i=0;i<4;i++) begin sel=i[1:0]; #1; if (y !== d[sel]) begin bad++; $display("FAIL sel=%0d", i); end end
        if (bad==0) $display("EX_02 ALL TESTS PASS"); else $display("EX_02 FAIL: %0d", bad);
    end
endmodule
