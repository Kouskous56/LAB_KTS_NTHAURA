`timescale 1ns/1ps
module tb;
    logic A = 1'b0, B = 1'b0, Ci = 1'b0;
    logic S, Co;
    full_adder u (.A(A), .B(B), .Ci(Ci), .S(S), .Co(Co));

    int bad = 0;
    logic [1:0] exp;

    // truth table Table 3.1: A B Ci -> S Co
    function automatic logic [1:0] expected(input logic a, b, c);
        logic s  = a ^ b ^ c;
        logic co = (a & b) | (a & c) | (b & c);
        return {co, s};
    endfunction

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");
        for (int v = 0; v < 8; v++) begin
            A = v[2]; B = v[1]; Ci = v[0];
            exp = expected(A, B, Ci);
            #1;
            if ({Co, S} !== exp) bad++;
            $display("A=%b B=%b Ci=%b | S=%b Co=%b (exp S=%b Co=%b) %s",
                     A, B, Ci, S, Co, exp[0], exp[1],
                     ({Co,S} === exp) ? "OK" : "FAIL");
        end
        if (bad == 0) $display("ALL 8 TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
