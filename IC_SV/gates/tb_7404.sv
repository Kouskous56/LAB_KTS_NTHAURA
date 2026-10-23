`timescale 1ns/1ps
module tb_7404;
    logic [5:0] a,y; ic_7404 u(.a(a),.y(y));
    int bad=0;
    initial begin
        for (int i=0;i<64;i++) begin a=i[5:0]; #1; if (y !== ~a) begin bad++; if(bad<=5)$display("FAIL"); end end
        if (bad==0) $display("7404 ALL TESTS PASS"); else $display("7404 FAIL: %0d", bad);
    end
endmodule
