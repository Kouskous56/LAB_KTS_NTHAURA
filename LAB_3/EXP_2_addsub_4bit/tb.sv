`timescale 1ns/1ps
module tb;
    logic Sel = 1'b0;
    logic [3:0] A = 4'b0, B = 4'b0;
    logic [3:0] S;
    logic Cout;
    full_addsub_4bit u (.Sel(Sel), .A(A), .B(B), .S(S), .Cout(Cout));

    int bad = 0;
    int pair_a [12] = '{10,14,12,5,4,13,6,2,1,7,15,9};
    int pair_b [12] = '{11,10, 4,3,5,13,9,8,2,1, 6,15};
    int res;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");

        // 12 operand pairs from Table 3.4, each in both modes
        for (int i = 0; i < 12; i++) begin
            A = pair_a[i][3:0];
            B = pair_b[i][3:0];
            // Sel = 0 : addition
            Sel = 1'b0; #1;
            res = pair_a[i] + pair_b[i];
            if (S !== res[3:0] || Cout !== (res > 15)) begin
                bad++;
                $display("FAIL add %0d+%0d S=%b Cout=%b", pair_a[i], pair_b[i], S, Cout);
            end else
                $display("ADD %0d+%0d = %0d (Cout=%b) OK", pair_a[i], pair_b[i], S, Cout);
            // Sel = 1 : subtraction
            Sel = 1'b1; #1;
            res = pair_a[i] - pair_b[i];
            if (S !== res[3:0] || Cout !== (res >= 0)) begin
                bad++;
                $display("FAIL sub %0d-%0d S=%b Cout=%b", pair_a[i], pair_b[i], S, Cout);
            end else
                $display("SUB %0d-%0d = %0d (Cout=%b) OK", pair_a[i], pair_b[i], S, Cout);
        end

        if (bad == 0) $display("ALL TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
