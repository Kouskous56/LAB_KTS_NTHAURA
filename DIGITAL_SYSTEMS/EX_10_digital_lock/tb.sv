`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1, x=0, enter=0;
    logic unlock, error;
    digital_lock u (.clk(clk),.rst(rst),.x(x),.enter(enter),.unlock(unlock),.error(error));
    int bad=0;
    initial begin
        rst=1;
        for (int i=0;i<2;i++) begin clk=0; #5; clk=1; #5; clk=0; #5; end
        rst=0; #5;
        // Enter password 1,0,1
        x=1; enter=1; clk=0; #5; clk=1; #5; clk=0; #5; enter=0; #5;
        x=0; enter=1; clk=0; #5; clk=1; #5; clk=0; #5; enter=0; #5;
        x=1; enter=1; clk=0; #5; clk=1; #5; clk=0; #5; enter=0; #5;
        // Should unlock (state=UNLOCK right after third enter clock)
        if (unlock !== 1) begin bad++; $display("FAIL unlock: %b", unlock); end
        // Extra clock -> back to IDLE
        clk=0; #5; clk=1; #5; clk=0; #5;
        // Wrong password
        rst=1;
        for (int i=0;i<2;i++) begin clk=0; #5; clk=1; #5; clk=0; #5; end
        rst=0; #5;
        x=0; enter=1; clk=0; #5; clk=1; #5; clk=0; #5; enter=0; #5;
        clk=0; #5; clk=1; #5; clk=0; #5;
        if (error !== 1) begin bad++; $display("FAIL error"); end
        if (bad==0) $display("EX_10 ALL TESTS PASS"); else $display("EX_10 FAIL: %0d", bad);
        $finish;
    end
endmodule
