`timescale 1ns/1ps
module tb_74244;
    logic [7:0] a; logic oe1_n,oe2_n; tri [7:0] y;
    ic_74244 u(.a(a),.oe1_n(oe1_n),.oe2_n(oe2_n),.y(y));
    int bad=0;
    initial begin
        a=8'hA5; oe1_n=0; oe2_n=0; #1;
        if (y !== 8'hA5) begin bad++; $display("FAIL en"); end
        oe1_n=1; #1;
        if (y[3:0] !== 4'bz) begin bad++; $display("FAIL g1 dis"); end
        if (y[7:4] !== a[7:4]) begin bad++; $display("FAIL g2 still"); end
        if (bad==0) $display("74244 ALL TESTS PASS"); else $display("74244 FAIL: %0d", bad);
    end
endmodule
