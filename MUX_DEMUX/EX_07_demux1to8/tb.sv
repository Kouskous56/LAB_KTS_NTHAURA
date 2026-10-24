`timescale 1ns/1ps
module tb;
    logic d; logic [2:0] sel; logic [7:0] y;
    demux1to8 u (.d(d),.sel(sel),.y(y));
    int bad=0;
    logic [7:0] exp;
    initial begin
        for (int i=0;i<16;i++) begin
            d = i[3]; sel = i[2:0]; #1;
            exp = 8'b0;
            exp[sel] = d;
            if (y !== exp) begin bad++; $display("FAIL d=%b sel=%0d", d, sel); end
        end
        if (bad==0) $display("EX_07 ALL TESTS PASS"); else $display("EX_07 FAIL: %0d", bad);
    end
endmodule
