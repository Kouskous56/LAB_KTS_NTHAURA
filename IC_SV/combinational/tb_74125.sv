`timescale 1ns/1ps
module tb_74125;
    logic [3:0] a, e_n; tri [3:0] y;
    ic_74125 u(.a(a),.e_n(e_n),.y(y));
    int bad=0;
    initial begin
        a=4'b1010; e_n=4'b0000; #1;
        if (y !== 4'b1010) begin bad++; $display("FAIL en"); end
        e_n=4'b1111; #1;
        if (y !== 4'bz) begin bad++; $display("FAIL dis: %b", y); end
        if (bad==0) $display("74125 ALL TESTS PASS"); else $display("74125 FAIL: %0d", bad);
    end
endmodule
