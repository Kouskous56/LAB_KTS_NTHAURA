`timescale 1ns/1ps
module tb_74121;
    logic a1_n=1, a2_n=1, b=0; logic q, q_n;
    ic_74121 u (.a1_n(a1_n),.a2_n(a2_n),.b(b),.q(q),.q_n(q_n));
    int bad=0;
    initial begin
        #5;
        // trigger via B (A inputs high)
        b = 1; #2; b = 0;
        #1;
        if (q !== 1'b1) begin bad++; $display("FAIL trigger: q=%b", q); end
        #200;
        if (q !== 1'b0) begin bad++; $display("FAIL timeout: q=%b", q); end
        if (bad==0) $display("74121 ALL TESTS PASS"); else $display("74121 FAIL: %0d", bad);
    end
endmodule
