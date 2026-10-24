`timescale 1ns/1ps
module tb;
    logic [7:0] d; logic [2:0] sel; logic y;
    mux8to1 u (.d(d),.sel(sel),.y(y));
    int bad=0;
    initial begin
        d = 8'b10101010;
        for (int i=0;i<8;i++) begin sel=i[2:0]; #1; if (y !== d[sel]) begin bad++; $display("FAIL sel=%0d", i); end end
        if (bad==0) $display("EX_03 ALL TESTS PASS"); else $display("EX_03 FAIL: %0d", bad);
    end
endmodule
