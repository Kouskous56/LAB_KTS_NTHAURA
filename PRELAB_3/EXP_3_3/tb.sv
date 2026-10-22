`timescale 1ns/1ps
module tb;
    logic clk = 1'b0, clr = 1'b1;
    logic [2:0] Q;
    counter_0_7 u (.clk(clk), .clr(clr), .Q(Q));

    int bad = 0;
    int cycle = 0;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");
        // reset to 000
        clr = 1'b0; #1; clr = 1'b1; #1;
        if (Q !== 3'b000) begin bad++; $display("FAIL reset Q=%b", Q); end
        else $display("reset Q=%b OK", Q);
        // count 0..7 then wrap to 0
        for (int i = 0; i < 9; i++) begin
            clk = 1'b1; #1;
            clk = 1'b0; #1;
            cycle++;
            if (Q !== cycle[2:0]) begin
                bad++;
                $display("FAIL cycle %0d Q=%b", cycle, Q);
            end else
                $display("cycle %0d Q=%b OK", cycle, Q);
        end
        if (bad == 0) $display("ALL TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
