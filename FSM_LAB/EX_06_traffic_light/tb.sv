`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1, tick_1s=0;
    logic green, yellow, red;
    traffic_light u (.clk(clk),.rst(rst),.tick_1s(tick_1s),.green(green),.yellow(yellow),.red(red));
    int bad=0;
    task automatic tick(); tick_1s=1; @(posedge clk); #1; tick_1s=0; @(posedge clk); #1; endtask
    initial begin
        rst=1;
        for (int i=0;i<2;i++) begin clk=0; #5; clk=1; #5; clk=0; #5; end
        rst=0; #5;
        // GREEN
        if (green!==1) begin bad++; $display("FAIL init green"); end
        tick(); tick(); // 2 ticks (timer 2->0)
        tick(); // transition to YELLOW
        if (yellow!==1) begin bad++; $display("FAIL yellow"); end
        tick(); tick(); // 2 ticks
        tick(); // transition to RED
        if (red!==1) begin bad++; $display("FAIL red"); end
        tick(); tick(); tick(); // 3 ticks
        if (green!==1) begin bad++; $display("FAIL back to green"); end
        if (bad==0) $display("EX_06 ALL TESTS PASS"); else $display("EX_06 FAIL: %0d", bad);
        $finish;
    end
    always #5 clk = ~clk;
endmodule
