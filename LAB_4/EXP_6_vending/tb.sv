`timescale 1ns/1ps
module tb;
    logic clk = 1'b0;
    logic rst = 1'b1;
    logic red = 1'b0, blue = 1'b0;
    logic food, water;
    vending_fsm u (.clk(clk), .rst(rst), .red(red), .blue(blue), .food(food), .water(water));
    int bad = 0;

    task automatic press(input logic r, input logic b);
        red = r; blue = b;
        @(posedge clk); #1;
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        repeat (2) @(posedge clk);
        rst = 1'b0;

        // RED x3 -> FOOD
        press(1,0); press(1,0); press(1,0);
        if (food !== 1 || water !== 0) begin bad++; $display("FAIL: after REDx3 food=%b water=%b", food, water); end

        // press again -> reset
        press(1,0);
        if (food !== 0) begin bad++; $display("FAIL: FOOD not cleared on press"); end

        // reset
        rst = 1'b1; @(posedge clk); #1; rst = 1'b0;

        // BLUE x2 -> WATER
        press(0,1); press(0,1);
        if (water !== 1 || food !== 0) begin bad++; $display("FAIL: after BLUE x2 water=%b food=%b", water, food); end

        // wrong order: RED,RED,BLUE -> no output
        rst = 1'b1; @(posedge clk); #1; rst = 1'b0;
        press(1,0); press(1,0); press(0,1);
        if (food !== 0 || water !== 0) begin bad++; $display("FAIL: wrong order produced output food=%b water=%b", food, water); end

        if (bad == 0) $display("ALL TESTS PASS");
        else          $display("FAIL: %0d errors", bad);
        $finish;
    end
    always #5 clk = ~clk;
endmodule
