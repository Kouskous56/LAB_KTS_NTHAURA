`timescale 1ns/1ps
module tb;
    logic clk = 1'b0;
    logic rst = 1'b1;
    logic sw0 = 1'b0;
    logic tick_1s = 1'b0;
    logic ns_g, ns_y, ns_r, ew_g, ew_y, ew_r;
    logic [3:0] timer;
    traffic_fsm_manual u (.clk(clk), .rst(rst), .sw0(sw0), .tick_1s(tick_1s),
                         .ns_g(ns_g), .ns_y(ns_y), .ns_r(ns_r),
                         .ew_g(ew_g), .ew_y(ew_y), .ew_r(ew_r), .timer(timer));
    int bad = 0;

    task automatic tick(); tick_1s = 1'b1; @(posedge clk); #1; tick_1s = 1'b0; @(posedge clk); #1; endtask

    initial begin
        $dumpfile("wave.vcd"); $dumpvars(0, tb);
        rst = 1'b1; sw0 = 1'b0;
        repeat (2) @(posedge clk);
        rst = 1'b0;

        // Initial: NS_GO (NS green, EW red)
        if (ns_g !== 1 || ew_r !== 1) begin bad++; $display("FAIL init"); end

        // Switch to EW: should go NS_WARN
        sw0 = 1'b1;
        tick();
        if (ns_y !== 1 || ew_r !== 1) begin bad++; $display("FAIL NS_WARN outputs"); end
        if (timer !== 4'd3) begin bad++; $display("FAIL timer init: %0d", timer); end

        // 3 ticks of yellow
        tick(); if (timer !== 4'd2) begin bad++; $display("FAIL timer: %0d", timer); end
        tick(); if (timer !== 4'd1) begin bad++; $display("FAIL timer: %0d", timer); end
        tick(); // transition to EW_GO
        if (ew_g !== 1 || ns_r !== 1) begin bad++; $display("FAIL EW_GO outputs"); end

        // Switch back to NS
        sw0 = 1'b0;
        tick();
        if (ew_y !== 1 || ns_r !== 1) begin bad++; $display("FAIL EW_WARN outputs"); end
        tick(); tick(); tick(); // 3 ticks
        if (ns_g !== 1 || ew_r !== 1) begin bad++; $display("FAIL back to NS_GO"); end

        if (bad == 0) $display("EXP_1 ALL TESTS PASS"); else $display("EXP_1 FAIL: %0d", bad);
        $finish;
    end

    always #5 clk = ~clk;
endmodule
