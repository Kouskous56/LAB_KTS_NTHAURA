`timescale 1ns/1ps
module tb_74374;
    logic clk=0; logic [7:0] d; logic oe_n; tri [7:0] q;
    ic_74374 u (.clk(clk),.d(d),.oe_n(oe_n),.q(q));
    int bad=0;
    initial begin
        oe_n=0; d=8'hA5;
        clk=0; #5; clk=1; #5; clk=0;
        if (q!==8'hA5) begin bad++; $display("FAIL capture"); end
        d=8'h3C; #5; clk=1; #5; clk=0;
        if (q!==8'h3C) begin bad++; $display("FAIL capture2: %b", q); end
        oe_n=1; #5; if (q !== 8'bz) begin bad++; $display("FAIL OE: %b", q); end
        if (bad==0) $display("74374 ALL TESTS PASS"); else $display("74374 FAIL: %0d", bad);
    end
endmodule
