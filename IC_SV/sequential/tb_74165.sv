`timescale 1ns/1ps
module tb_74165;
    logic clk=0; logic sh_ld_n=1, clk_inh=0; logic ser=0; logic [7:0] d; logic qh, qh_n;
    ic_74165 u (.clk(clk),.sh_ld_n(sh_ld_n),.clk_inh(clk_inh),.ser(ser),.d(d),.qh(qh),.qh_n(qh_n));
    int bad=0;
    logic [7:0] collected;
    task automatic clkp(); clk=0; #5; clk=1; #5; clk=0; #5; endtask
    initial begin
        // parallel load
        sh_ld_n=0; d=8'hA5; clkp(); sh_ld_n=1;
        if (qh !== d[7]) begin bad++; $display("FAIL load qh"); end
        collected = 8'b0;
        // shift 8 times, collect serial out
        for (int i=0;i<8;i++) begin collected = {collected[6:0], qh}; clkp(); end
        if (collected !== 8'hA5) begin bad++; $display("FAIL collect: %b", collected); end
        if (bad==0) $display("74165 ALL TESTS PASS"); else $display("74165 FAIL: %0d", bad);
    end
endmodule
