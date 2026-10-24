`timescale 1ns/1ps
module tb;
    logic clk=0, rst=0;
    logic [5:0] count;
    logic carry;

    counter_0_42 u (.clk(clk), .rst(rst), .count(count), .carry(carry));

    int bad = 0;

    initial begin
        #5; rst=1; #10; rst=0; #5;
        // After reset, count should be 0
        if (count !== 6'd0) begin bad++; $display("FAIL init: %0d", count); end
        for (int i = 0; i < 42; i++) begin
            clk=0; #5; clk=1; #5; clk=0; #5;
            if (count !== (i+1)) begin
                bad++;
                $display("FAIL: expected %0d, got %0d", i+1, count);
            end
        end
        // One more tick to wrap to 0
        clk=0; #5; clk=1; #5; clk=0; #5;
        if (count !== 6'd0) begin bad++; $display("FAIL wrap: %0d", count); end
        if (bad == 0) $display("EX_14 ALL TESTS PASS");
        else          $display("EX_14 FAIL: %0d", bad);
        $finish;
    end
endmodule
