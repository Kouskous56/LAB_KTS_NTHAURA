`timescale 1ns/1ps
module tb;
    logic clk = 1'b0;
    logic rst = 1'b1;
    logic sw0 = 1'b0, sw1 = 1'b0;
    logic tick_1s = 1'b0;
    logic ns_g, ns_y, ns_r, ew_g, ew_y, ew_r;
    logic [3:0] timer;
    traffic_fsm_integrated u (.clk(clk), .rst(rst), .sw0(sw0), .sw1(sw1), .tick_1s(tick_1s),
                             .ns_g(ns_g), .ns_y(ns_y), .ns_r(ns_r),
                             .ew_g(ew_g), .ew_y(ew_y), .ew_r(ew_r), .timer(timer));
    int bad = 0;

    task automatic tick(); tick_1s = 1'b1; @(posedge clk); #1; tick_1s = 1'b0; @(posedge clk); #1; endtask

    initial begin
        $dumpfile("wave.vcd"); $dumpvars(0, tb);
        rst = 1'b1; sw0 = 1'b0; sw1 = 1'b0;
        repeat (2) @(posedge clk);
        rst = 1'b0;

        // Manual mode: initial NS_GO
        if (ns_g !== 1 || ew_r !== 1) begin bad++; $display("FAIL init manual"); end

        // Manual: switch to EW
        sw0 = 1'b1;
        tick();
        if (ns_y !== 1 || ew_r !== 1) begin bad++; $display("FAIL manual NS_WARN"); end
        tick(); tick(); tick();
        if (ew_g !== 1 || ns_r !== 1) begin bad++; $display("FAIL manual EW_GO"); end

        // Switch to auto mode
        sw1 = 1'b1;
        tick();
        if (ns_g !== 1 || ew_r !== 1) begin bad++; $display("FAIL auto NS_GREEN"); end
        if (timer !== 4'd5) begin bad++; $display("FAIL auto timer: %0d", timer); end

        // Auto: 5 ticks of green
        tick(); tick(); tick(); tick();
        if (timer !== 4'd1) begin bad++; $display("FAIL auto green timer: %0d", timer); end
        tick(); // transition to yellow
        if (ns_y !== 1 || ew_r !== 1) begin bad++; $display("FAIL auto NS_YELLOW"); end
        if (timer !== 4'd2) begin bad++; $display("FAIL auto yellow timer: %0d", timer); end
        tick(); tick(); // 2 ticks of yellow
        if (ew_g !== 1 || ns_r !== 1) begin bad++; $display("FAIL auto EW_GREEN"); end

        if (bad == 0) $display("EXP_2 ALL TESTS PASS"); else $display("EXP_2 FAIL: %0d", bad);
        $finish;
    end

    always #5 clk = ~clk;
endmodule
