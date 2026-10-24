`timescale 1ns/1ps
module tb;
    logic [3:0] a; logic en; logic [15:0] y;
    dec4to16 u (.a(a),.en(en),.y(y));
    int bad=0;
    initial begin
        en = 1;
        for (int i=0;i<16;i++) begin a=i[3:0]; #1; if (y !== (16'b1<<a)) begin bad++; $display("FAIL a=%0d", a); end end
        en = 0; a=4'd0; #1;
        if (y !== 16'b0) begin bad++; $display("FAIL disable"); end
        if (bad==0) $display("EX_04 ALL TESTS PASS"); else $display("EX_04 FAIL: %0d", bad);
    end
endmodule
