`timescale 1ns/1ps
module tb;
    logic D = 1'b0, CLK = 1'b0, PRE = 1'b1, CLR = 1'b1;
    logic Q, QN;
    dff74ls74 u (.D(D), .CLK(CLK), .PRE(PRE), .CLR(CLR), .Q(Q), .QN(QN));

    int bad = 0;

    task automatic check(input logic q, input logic qn, input string label);
        begin
            if (Q !== q || QN !== qn) begin
                bad++;
                $display("FAIL %-22s : Q=%b Q'=%b (exp %b/%b)", label, Q, QN, q, qn);
            end else
                $display("%-22s : Q=%b Q'=%b OK", label, Q, QN);
        end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");

        // ---- asynchronous rows (Table 3.5, top) ----
        // PRE=0 CLR=0 -> nonstable (Q=1, Q'=1) per datasheet Note 1
        PRE = 1'b0; CLR = 1'b0; #1;
        check(1'b1, 1'b1, "PRE=0 CLR=0 (nonstable)");

        PRE = 1'b1; CLR = 1'b0; #1;                       // CLR asserted (negedge)
        check(1'b0, 1'b1, "PRE=1 CLR=0");

        PRE = 1'b0; CLR = 1'b1; #1;                       // PRE asserted (negedge)
        check(1'b1, 1'b0, "PRE=0 CLR=1");

        // ---- synchronous rows: output changes only on rising edge ----
        PRE = 1'b1; CLR = 1'b1; #1;                       // release async inputs
        D = 1'b0; CLK = 1'b0; #1;
        check(1'b1, 1'b0, "D=0 CLK=0");

        D = 1'b1; CLK = 1'b0; #1;
        check(1'b1, 1'b0, "D=1 CLK=0");

        D = 1'b0; CLK = 1'b1; #1;                         // rising edge, D=0
        check(1'b0, 1'b1, "D=0 CLK=1 (rise)");

        D = 1'b1; CLK = 1'b1; #1;                         // no new edge
        check(1'b0, 1'b1, "D=1 CLK=1");

        D = 1'b0; CLK = 1'b0; #1;                         // falling edge
        check(1'b0, 1'b1, "D=0 CLK=0 (fall)");

        D = 1'b1; CLK = 1'b0; #1;
        check(1'b0, 1'b1, "D=1 CLK=0");

        D = 1'b0; CLK = 1'b1; #1;                         // rising edge, D=0
        check(1'b0, 1'b1, "D=0 CLK=1 (rise)");

        CLK = 1'b0; #1; D = 1'b1; CLK = 1'b1; #1;         // rising edge, D=1
        check(1'b1, 1'b0, "D=1 CLK=1 (rise)");

        if (bad == 0) $display("ALL TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
