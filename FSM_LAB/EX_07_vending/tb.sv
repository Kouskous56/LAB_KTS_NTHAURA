`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1, coin=0, select=0;
    logic dispense, change;
    vending u (.clk(clk),.rst(rst),.coin(coin),.select(select),.dispense(dispense),.change(change));
    int bad=0;
    initial begin
        rst=1; #10; rst=0; #5;
        // Insert coin
        coin=1; clk=0; #5; clk=1; #5; clk=0; #5; coin=0;
        // Select product
        select=1; clk=0; #5; clk=1; #5; clk=0; #5; select=0;
        // Should dispense
        clk=0; #5; clk=1; #5; clk=0; #5;
        if (dispense !== 1) begin bad++; $display("FAIL dispense"); end
        // Back to idle
        clk=0; #5; clk=1; #5; clk=0; #5;
        if (dispense !== 0) begin bad++; $display("FAIL idle"); end
        if (bad==0) $display("EX_07 ALL TESTS PASS"); else $display("EX_07 FAIL: %0d", bad);
    end
endmodule
