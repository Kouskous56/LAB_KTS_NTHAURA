`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1, en=1; logic [3:0] count;
    counter_up u (.clk(clk),.rst(rst),.en(en),.count(count));
    int bad=0;
    initial begin
        rst=1; #10; rst=0; #5;
        for (int i=0;i<16;i++) begin
            clk=0; #5; clk=1; #5; clk=0; #5;
            if (count !== ((i+1)%16)) begin bad++; $display("FAIL count: %0d (exp %0d)", count, (i+1)%16); end
        end
        // enable=0: hold
        en=0; clk=1; #5; clk=0;
        if (count !== 4'd0) begin bad++; $display("FAIL hold"); end
        if (bad==0) $display("EX_07 ALL TESTS PASS"); else $display("EX_07 FAIL: %0d", bad);
    end
endmodule
