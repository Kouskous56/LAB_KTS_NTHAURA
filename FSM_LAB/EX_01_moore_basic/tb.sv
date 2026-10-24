`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1, x=0, z;
    moore_basic u (.clk(clk),.rst(rst),.x(x),.z(z));
    int bad=0;
    initial begin
        rst=1;
        for (int i=0;i<2;i++) begin clk=0; #5; clk=1; #5; clk=0; #5; end
        rst=0; #5;
        // IDLE: z=0
        x=0; clk=0; #5; clk=1; #5; clk=0; #5;
        if (z !== 0) begin bad++; $display("FAIL idle z"); end
        // -> ACTIVE
        x=1; clk=0; #5; clk=1; #5; clk=0; #5;
        if (z !== 1) begin bad++; $display("FAIL active z"); end
        // stay active
        x=1; clk=0; #5; clk=1; #5; clk=0; #5;
        if (z !== 1) begin bad++; $display("FAIL stay active"); end
        // -> IDLE
        x=0; clk=0; #5; clk=1; #5; clk=0; #5;
        if (z !== 0) begin bad++; $display("FAIL back to idle"); end
        if (bad==0) $display("EX_01 ALL TESTS PASS"); else $display("EX_01 FAIL: %0d", bad);
        $finish;
    end
endmodule
