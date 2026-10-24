`timescale 1ns/1ps
module tb;
    logic [1:0] a; logic [3:0] y;
    dec2to4 u (.a(a), .y(y));
    int bad=0;
    initial begin
        for (int i=0;i<4;i++) begin
            a = i[1:0]; #1;
            if (y !== (4'b1 << a)) begin bad++; $display("FAIL a=%0d got=%b", a, y); end
        end
        if (bad==0) $display("EX_01 ALL TESTS PASS"); else $display("EX_01 FAIL: %0d", bad);
    end
endmodule
