`timescale 1ns/1ps
module tb;
    logic [3:0] A;
    logic [3:0] S;
    absval_4bit u (.A(A), .S(S));
    int bad = 0;
    function automatic logic [3:0] exp(input logic [3:0] a);
        return a[3] ? ((~a + 4'd1)) : a;
    endfunction
    initial begin
        logic [3:0] e;
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        for (int i = 0; i < 16; i++) begin
            A = i[3:0];
            #1;
            e = exp(A);
            if (S !== e) begin
                bad++;
                $display("FAIL A=%0d: S=%0d (exp %0d)", A, S, e);
            end
        end
        if (bad == 0) $display("ALL TESTS PASS");
        else          $display("FAIL: %0d errors", bad);
        $finish;
    end
endmodule
