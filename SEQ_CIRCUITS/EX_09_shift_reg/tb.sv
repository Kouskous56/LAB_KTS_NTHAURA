`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1, si=0; logic [7:0] q;
    sr_sipo u (.clk(clk),.rst(rst),.si(si),.q(q));
    int bad=0;
    logic bits [0:7];
    initial begin
        rst=1; #10; rst=0; #5;
        // shift in 1,0,1,1,0,0,0,1
        bits = '{1,0,1,1,0,0,0,1};
        for (int i=0;i<8;i++) begin si=bits[i]; clk=0; #5; clk=1; #5; clk=0; #5; end
        if (q !== 8'b10110001) begin bad++; $display("FAIL shift: %b", q); end
        // clear
        rst=1; #10; rst=0; #5;
        if (q !== 8'b0) begin bad++; $display("FAIL clear"); end
        if (bad==0) $display("EX_09 ALL TESTS PASS"); else $display("EX_09 FAIL: %0d", bad);
    end
endmodule
