`timescale 1ns/1ps
module tb_74193;
    logic clr_n=1, ld_n=1; logic up_clk=0, down_clk=0; logic [3:0] d, q; logic carry_n, borrow_n;
    ic_74193 u (.clr_n(clr_n),.ld_n(ld_n),.up_clk(up_clk),.down_clk(down_clk),.d(d),.q(q),.carry_n(carry_n),.borrow_n(borrow_n));
    int bad=0;
    task automatic up_pulse(); up_clk=0; #5; up_clk=1; #5; up_clk=0; #5; endtask
    task automatic down_pulse(); down_clk=0; #5; down_clk=1; #5; down_clk=0; #5; endtask
    initial begin
        // clear
        clr_n=0; #2; clr_n=1; #2; if (q!==4'd0) begin bad++; $display("FAIL clear"); end
        // load 5
        d=4'd5; ld_n=0; up_pulse(); ld_n=1; #2; if (q!==4'd5) begin bad++; $display("FAIL load: %0d", q); end
        // count up 3
        up_pulse(); up_pulse(); up_pulse(); if (q!==4'd8) begin bad++; $display("FAIL up: %0d", q); end
        // count down 2
        down_pulse(); down_pulse(); if (q!==4'd6) begin bad++; $display("FAIL down: %0d", q); end
        if (bad==0) $display("74193 ALL TESTS PASS"); else $display("74193 FAIL: %0d", bad);
    end
endmodule
