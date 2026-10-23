`timescale 1ns/1ps
module tb;
    logic a = 1'b0, b = 1'b0, ci = 1'b0;
    logic s, co;
    FA_ex1 u (.a(a), .b(b), .ci(ci), .s(s), .co(co));
    int bad = 0;
    function automatic logic e_s(input logic a, b, ci); return a ^ b ^ ci; endfunction
    function automatic logic e_co(input logic a, b, ci); return (a & b) | (a & ci) | (b & ci); endfunction
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        for (int i = 0; i < 8; i++) begin
            {a, b, ci} = i[2:0];
            #1;
            if (s !== e_s(a, b, ci) || co !== e_co(a, b, ci)) begin
                bad++;
                $display("FAIL %0d", i);
            end
        end
        if (bad == 0) $display("ALL TESTS PASS");
        else          $display("FAIL: %0d errors", bad);
    end
endmodule
