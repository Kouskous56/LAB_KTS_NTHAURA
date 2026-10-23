`timescale 1ns/1ps
module tb;
    logic clk = 1'b0;
    logic rst = 1'b1;
    logic out;

    clock_divider_core #(.DIVISOR(4)) u (.clk_in(clk), .rst_in(rst), .out_signal(out));

    int bad = 0;

    initial begin
        logic prev;
        int toggles;
        int last_toggle_cycle;
        int min_gap;
        int gap;
        prev = 1'b0;
        toggles = 0;
        last_toggle_cycle = 0;
        min_gap = 1000;
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        repeat (2) @(posedge clk);
        rst = 1'b0;
        for (int i = 1; i <= 20; i++) begin
            @(posedge clk);
            #1;
            if (out !== 1'b0 && out !== 1'b1) begin
                bad++;
                $display("FAIL cycle %0d: out is X/Z", i);
            end
            if (out !== prev) begin
                toggles++;
                if (last_toggle_cycle != 0) begin
                    gap = i - last_toggle_cycle;
                    if (gap < min_gap) min_gap = gap;
                end
                last_toggle_cycle = i;
                prev = out;
            end
        end
        if (toggles < 4) begin bad++; $display("FAIL: only %0d toggles (exp >=4)", toggles); end
        if (min_gap != 1000 && min_gap < 4) begin bad++; $display("FAIL: min toggle gap %0d (exp >=4)", min_gap); end
        if (bad == 0) $display("ALL TESTS PASS (toggles=%0d, min_gap=%0d)", toggles, min_gap);
        else          $display("FAIL: %0d errors", bad);
        $finish;
    end
    always #5 clk = ~clk;
endmodule
