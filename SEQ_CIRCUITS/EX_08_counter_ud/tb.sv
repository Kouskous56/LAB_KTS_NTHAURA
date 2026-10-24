`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1, en=1, up=1; logic [3:0] count;
    counter_ud u (.clk(clk),.rst(rst),.en(en),.up(up),.count(count));
    int bad=0;
    initial begin
        rst=1; #10; rst=0; #5;
        // count up 5
        for (int i=0;i<5;i++) begin clk=0; #5; clk=1; #5; clk=0; end
        if (count !== 4'd5) begin bad++; $display("FAIL up: %0d", count); end
        // count down 3
        up=0;
        for (int i=0;i<3;i++) begin clk=0; #5; clk=1; #5; clk=0; end
        if (count !== 4'd2) begin bad++; $display("FAIL down: %0d", count); end
        // enable=0: hold
        en=0; clk=0; #5; clk=1; #5; clk=0;
        if (count !== 4'd2) begin bad++; $display("FAIL hold"); end
        if (bad==0) $display("EX_08 ALL TESTS PASS"); else $display("EX_08 FAIL: %0d", bad);
    end
endmodule
