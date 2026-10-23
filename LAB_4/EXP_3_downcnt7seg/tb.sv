`timescale 1ns/1ps
module tb;
    logic clk = 1'b0;
    logic rst = 1'b1;
    logic [2:0] count;
    down_counter_3bit u (.clk(clk), .rst(rst), .count(count));
    int bad = 0;
    // expected sequence after reset: 0,7,6,5,4,3,2,1,0
    logic [2:0] exp_seq [0:8] = '{3'd0,3'd7,3'd6,3'd5,3'd4,3'd3,3'd2,3'd1,3'd0};
    initial begin
        logic [2:0] exp_seq2 [0:7];
        exp_seq2 = '{3'd7,3'd6,3'd5,3'd4,3'd3,3'd2,3'd1,3'd0};
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        rst = 1'b1;
        repeat (2) @(posedge clk);
        rst = 1'b0;
        if (count !== 3'd0) begin bad++; $display("FAIL reset: count=%0d", count); end
        for (int i = 0; i < 8; i++) begin
            @(posedge clk);
            #1;
            if (count !== exp_seq2[i]) begin
                bad++;
                $display("FAIL step %0d: count=%0d (exp %0d)", i, count, exp_seq2[i]);
            end
        end
        // reset mid-stream
        rst = 1'b1;
        @(posedge clk); #1;
        if (count !== 3'd0) begin bad++; $display("FAIL reset: count=%0d", count); end
        rst = 1'b0;
        if (bad == 0) $display("ALL TESTS PASS");
        else          $display("FAIL: %0d errors", bad);
        $finish;
    end
    always #5 clk = ~clk;
endmodule
