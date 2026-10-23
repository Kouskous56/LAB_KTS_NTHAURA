`timescale 1ns/1ps
module tb_74148;
    logic [7:0] i_n; logic [2:0] a; logic gs_n, eo_n;
    ic_74148 u(.i_n(i_n),.a(a),.gs_n(gs_n),.eo_n(eo_n));
    int bad=0;
    initial begin
        i_n = 8'hFF; #1;
        if (gs_n !== 1 || eo_n !== 0) begin bad++; $display("FAIL none"); end
        i_n = 8'b11111110; #1; // input 0 active
        if (a !== 3'b111 || gs_n !== 0) begin bad++; $display("FAIL i0: a=%b", a); end
        i_n = 8'b11111101; #1; // input 1 active (higher? no, 0 higher; but 0 inactive here)
        if (a !== 3'b110) begin bad++; $display("FAIL i1: a=%b", a); end
        // priority: input 3 and 5 active -> should report 3
        i_n = ~(8'b00101000); #1;
        if (a !== 3'b100) begin bad++; $display("FAIL priority: a=%b", a); end
        if (bad==0) $display("74148 ALL TESTS PASS"); else $display("74148 FAIL: %0d", bad);
    end
endmodule
