`timescale 1ns/1ps
module tb;
    logic [3:0] A, B;
    logic       sel;
    logic [3:0] S1, S2;
    logic       Co1, Co2;
    addsub_4bit_m1 u1 (.A(A), .B(B), .sel(sel), .S(S1), .Co(Co1));
    addsub_4bit_m2 u2 (.A(A), .B(B), .sel(sel), .S(S2), .Co(Co2));
    int bad = 0;
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        for (int s = 0; s < 2; s++)
            for (int a = 0; a < 16; a++)
                for (int b = 0; b < 16; b++) begin
                    logic [3:0] eS;
                    logic       eCo;
                    sel = s[0]; A = a[3:0]; B = b[3:0];
                    #1;
                    eS  = sel ? (A - B) : (A + B);
                    eCo = sel ? (A >= B) : (({1'b0,A} + B) >= 16);
                    if (S1 !== eS || Co1 !== eCo || S2 !== eS || Co2 !== eCo ||
                        S1 !== S2 || Co1 !== Co2) begin
                        bad++;
                        if (bad <= 5)
                            $display("FAIL sel=%b A=%0d B=%0d : S1=%0d Co1=%b S2=%0d Co2=%b (exp S=%0d Co=%b)",
                                     sel, A, B, S1, Co1, S2, Co2, eS, eCo);
                    end
                end
        if (bad == 0) $display("ALL TESTS PASS");
        else          $display("FAIL: %0d errors", bad);
    end
endmodule
