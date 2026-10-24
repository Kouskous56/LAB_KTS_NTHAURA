`timescale 1ns/1ps
module tb;
    logic d; logic [1:0] sel; logic [3:0] y;
    demux1to4 u (.d(d),.sel(sel),.y(y));
    int bad=0;
    logic [3:0] exp;
    initial begin
        for (int i=0;i<8;i++) begin
            d = i[2]; sel = i[1:0]; #1;
            exp = 4'b0;
            exp[sel] = d;
            if (y !== exp) begin bad++; $display("FAIL d=%b sel=%0d got=%b exp=%b", d, sel, y, exp); end
        end
        if (bad==0) $display("EX_06 ALL TESTS PASS"); else $display("EX_06 FAIL: %0d", bad);
    end
endmodule
