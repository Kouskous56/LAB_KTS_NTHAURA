`timescale 1ns/1ps
module tb_74166;
    logic clk=0; logic sh_ld_n=1, clk_inh=0, clr_n=1; logic ser=0; logic [7:0] d; logic qh;
    ic_74166 u (.clk(clk),.sh_ld_n(sh_ld_n),.clk_inh(clk_inh),.clr_n(clr_n),.ser(ser),.d(d),.qh(qh));
    int bad=0;
    logic [7:0] collected;
    task automatic clkp(); clk=0; #5; clk=1; #5; clk=0; #5; endtask
    initial begin
        // clear
        clr_n=0; #2; clr_n=1; #2;
        // parallel load
        sh_ld_n=0; d=8'h5A; clkp(); sh_ld_n=1;
        if (qh !== d[7]) begin bad++; $display("FAIL load"); end
        // clock inhibit: no shift
        clk_inh=1; clkp(); clkp(); if (qh !== d[7]) begin bad++; $display("FAIL inhibit changed"); end
        clk_inh=0;
        collected = 8'b0;
        // shift out all bits
        for (int i=0;i<8;i++) begin collected = {collected[6:0], qh}; clkp(); end
        if (collected !== 8'h5A) begin bad++; $display("FAIL collect: %b", collected); end
        if (bad==0) $display("74166 ALL TESTS PASS"); else $display("74166 FAIL: %0d", bad);
    end
endmodule
