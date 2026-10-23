`timescale 1ns/1ps
module tb_74194;
    logic clk=0, clr_n=1; logic s1=0,s0=0; logic sil=0,sir=0; logic [3:0] d, q;
    ic_74194 u (.clk(clk),.clr_n(clr_n),.s1(s1),.s0(s0),.sil(sil),.sir(sir),.d(d),.q(q));
    int bad=0;
    task automatic clkp(); clk=0; #5; clk=1; #5; clk=0; #5; endtask
    initial begin
        // parallel load 1010
        s1=1; s0=1; d=4'b1010; clkp(); s1=0; s0=0;
        if (q!==4'b1010) begin bad++; $display("FAIL load: %b", q); end
        // shift right (serial in 1)
        s1=0; s0=1; sir=1; clkp(); if (q!==4'b1101) begin bad++; $display("FAIL shr: %b", q); end
        // shift left (serial in 0)
        s1=1; s0=0; sil=0; clkp(); if (q!==4'b1010) begin bad++; $display("FAIL shl: %b", q); end
        // hold
        s1=0; s0=0; clkp(); if (q!==4'b1010) begin bad++; $display("FAIL hold"); end
        // clear
        clr_n=0; #2; clr_n=1; #2; if (q!==4'b0) begin bad++; $display("FAIL clear"); end
        if (bad==0) $display("74194 ALL TESTS PASS"); else $display("74194 FAIL: %0d", bad);
    end
endmodule
