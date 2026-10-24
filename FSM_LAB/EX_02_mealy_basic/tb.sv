`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1, x=0, z;
    mealy_basic u (.clk(clk),.rst(rst),.x(x),.z(z));
    int bad=0;
    initial begin
        rst=1; #10; rst=0; #5;
        // IDLE, x=0 -> z=0
        x=0; clk=0; #5; clk=1; #5; clk=0; #5;
        if (z !== 0) begin bad++; $display("FAIL idle0"); end
        // IDLE, x=1 -> z=1 (Mealy: output depends on input)
        x=1; #5;
        if (z !== 1) begin bad++; $display("FAIL idle1: z=%b", z); end
        clk=0; #5; clk=1; #5; clk=0; #5;
        // ACTIVE, x=1 -> z=1
        if (z !== 1) begin bad++; $display("FAIL active1"); end
        // ACTIVE, x=0 -> z=0
        x=0; #5;
        if (z !== 0) begin bad++; $display("FAIL active0"); end
        if (bad==0) $display("EX_02 ALL TESTS PASS"); else $display("EX_02 FAIL: %0d", bad);
    end
endmodule
