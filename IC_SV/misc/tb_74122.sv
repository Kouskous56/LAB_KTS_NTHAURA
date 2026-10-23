`timescale 1ns/1ps
module tb_74122;
    logic a1_n=1, a2_n=1, b1=0, b2=0, clr_n=1; logic q, q_n;
    ic_74122 u (.a1_n(a1_n),.a2_n(a2_n),.b1(b1),.b2(b2),.clr_n(clr_n),.q(q),.q_n(q_n));
    int bad=0;
    initial begin
        #5;
        // trigger via B inputs
        b1=1; b2=1; #2; b1=0; b2=0;
        #1;
        if (q !== 1'b1) begin bad++; $display("FAIL trigger: q=%b", q); end
        // clear resets
        clr_n=0; #2; clr_n=1; #2;
        if (q !== 1'b0) begin bad++; $display("FAIL clear: q=%b", q); end
        if (bad==0) $display("74122 ALL TESTS PASS"); else $display("74122 FAIL: %0d", bad);
    end
endmodule
