`timescale 1ns/1ps
module tb;
    logic A = 1'b0, B = 1'b0, Ci = 1'b0;
    logic S, Co;
    full_adder u (.A(A), .B(B), .Ci(Ci), .S(S), .Co(Co));

    int bad = 0;
    logic [1:0] exp;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");
        // all 8 input combinations, check against Table 3.1
        for (int v = 0; v < 8; v++) begin
            A = v[2]; B = v[1]; Ci = v[0];
            exp = {A & B | A & Ci | B & Ci, A ^ B ^ Ci};
            #1;
            if ({Co, S} !== exp) bad++;
            $display("A=%b B=%b Ci=%b S=%b Co=%b %s", A, B, Ci, S, Co,
                     ({Co, S} === exp) ? "OK" : "FAIL");
        end
        if (bad == 0) $display("ALL 8 TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
