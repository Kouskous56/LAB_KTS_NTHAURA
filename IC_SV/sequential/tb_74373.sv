`timescale 1ns/1ps
module tb_74373;
    logic [7:0] d; logic le, oe_n; tri [7:0] q;
    ic_74373 u (.d(d),.le(le),.oe_n(oe_n),.q(q));
    int bad=0;
    initial begin
        le=1; oe_n=0; d=8'hA5; #5; if (q!==8'hA5) begin bad++; $display("FAIL transp"); end
        le=0; d=8'h00; #5; if (q!==8'hA5) begin bad++; $display("FAIL hold"); end
        oe_n=1; #5; if (q !== 8'bz) begin bad++; $display("FAIL OE"); end
        if (bad==0) $display("74373 ALL TESTS PASS"); else $display("74373 FAIL: %0d", bad);
    end
endmodule
