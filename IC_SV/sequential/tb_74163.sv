`timescale 1ns/1ps
module tb_74163;
    logic clk=0; logic clr_n=1, ld_n=1, enp=1, ent=1; logic [3:0] d, q; logic rco;
    ic_74163 u (.clk(clk),.clr_n(clr_n),.ld_n(ld_n),.enp(enp),.ent(ent),.d(d),.q(q),.rco(rco));
    int bad=0;
    task automatic clkp(); clk=0; #5; clk=1; #5; clk=0; #5; endtask
    initial begin
        // clear
        clr_n=0; clkp(); if (q!==4'd0) begin bad++; $display("FAIL clear"); end; clr_n=1;
        // load 7
        d=4'd7; ld_n=0; clkp(); ld_n=1; if (q!==4'd7) begin bad++; $display("FAIL load"); end
        // count up 3
        clkp(); clkp(); clkp(); if (q!==4'd10) begin bad++; $display("FAIL count: %0d", q); end
        // count to F and check RCO
        d=4'hD; ld_n=0; clkp(); ld_n=1;
        clkp(); clkp();
        if (q!==4'hF) begin bad++; $display("FAIL count-to-F: %0d", q); end
        if (rco !== (ent && (q==4'hF))) begin bad++; $display("FAIL rco: %b", rco); end
        if (bad==0) $display("74163 ALL TESTS PASS"); else $display("74163 FAIL: %0d", bad);
    end
endmodule
