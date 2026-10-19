`timescale 1ns/1ps
module tb;
    logic A, B, C, D, E;
    logic yA, yN, yRef;

    code_andor ua (.A(A), .B(B), .C(C), .D(D), .E(E), .Y(yA));
    code_nand  un (.A(A), .B(B), .C(C), .D(D), .E(E), .Y(yN));

    // reference: valid code iff A=B=C
    assign yRef = (~A & ~B & ~C) | (A & B & C);

    int bad = 0;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");
        // sweep all 32 input combinations
        for (int v = 0; v < 32; v++) begin
            {E, D, C, B, A} = v[4:0];
            #1;
            if (yA !== yRef || yN !== yRef || yA !== yN) begin
                $display("FAIL EDCBA=%b%b%b%b%b yA=%b yN=%b ref=%b", E, D, C, B, A, yA, yN, yRef);
                bad++;
            end
        end
        if (bad == 0) $display("ALL 32 TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
