`timescale 1ns/1ps
module tb;
    logic d, sel, y0, y1;
    demux1to2 u (.d(d),.sel(sel),.y0(y0),.y1(y1));
    int bad=0;
    initial begin
        for (int i=0;i<8;i++) begin
            {d,sel} = i[1:0]; // only 2 bits needed, but i goes 0-7
            d = i[1]; sel = i[0]; #1;
            if (sel==0) begin if (y0 !== d || y1 !== 0) begin bad++; $display("FAIL sel=0"); end end
            else begin if (y0 !== 0 || y1 !== d) begin bad++; $display("FAIL sel=1"); end end
        end
        if (bad==0) $display("EX_05 ALL TESTS PASS"); else $display("EX_05 FAIL: %0d", bad);
    end
endmodule
