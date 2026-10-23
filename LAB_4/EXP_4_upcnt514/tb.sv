`timescale 1ns/1ps
module tb;
    logic clk = 1'b0;
    logic rst = 1'b1;
    logic [3:0] count;
    up_counter_5to14 u (.clk(clk), .rst(rst), .count(count));
    int bad = 0;
    logic [3:0] exp_seq [0:11] = '{4'd5,4'd6,4'd7,4'd8,4'd9,4'd10,4'd11,4'd12,4'd13,4'd14,4'd5,4'd6};
    initial begin
        logic [3:0] exp_seq2 [0:10];
        exp_seq2 = '{4'd6,4'd7,4'd8,4'd9,4'd10,4'd11,4'd12,4'd13,4'd14,4'd5,4'd6};
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        rst = 1'b1;
        repeat (2) @(posedge clk);
        rst = 1'b0;
        if (count !== 4'd5) begin bad++; $display("FAIL reset: count=%0d", count); end
        for (int i = 0; i < 11; i++) begin
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
        if (count !== 4'd5) begin bad++; $display("FAIL reset: count=%0d", count); end
        rst = 1'b0;
        if (bad == 0) $display("ALL TESTS PASS");
        else          $display("FAIL: %0d errors", bad);
        $finish;
    end
    always #5 clk = ~clk;
endmodule
