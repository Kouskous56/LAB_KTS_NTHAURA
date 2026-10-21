`timescale 1ns/1ps
module tb;
    logic clk = 1'b0, clr = 1'b1, X = 1'b0;
    logic [1:0] S;
    fsm_fig34 u (.clk(clk), .clr(clr), .X(X), .S(S));

    int bad = 0;
    int seq[7] = '{0,1,1,0,0,0,1};
    logic [1:0] exp_state[7];

    task automatic tick(input logic x);
        begin
            X = x;
            #1 clk = 1'b1; #1 clk = 1'b0; #1;
        end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");
        // reset to state A
        clr = 1'b0; #1; clr = 1'b1; #1;
        if (S !== 2'b00) begin bad++; $display("FAIL reset S=%b", S); end
        else $display("reset -> A (00) OK");

        // run the manual input sequence 0 1 1 0 0 0 1 from state A
        $display("--- input sequence 0 1 1 0 0 0 1 ---");
        for (int i = 0; i < 7; i++) begin
            $display("before input %0d : state=%b", seq[i], S);
            tick(seq[i][0]);
        end
        $display("final state = %b (B expected)", S);
        if (S !== 2'b01) begin bad++; $display("FAIL final state %b", S); end

        if (bad == 0) $display("ALL TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
