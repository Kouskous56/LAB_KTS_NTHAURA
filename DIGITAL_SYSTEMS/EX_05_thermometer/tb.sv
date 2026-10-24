`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1; logic [7:0] temp_raw=8'd0, threshold=8'd50;
    logic [7:0] temp_display; logic alarm;
    thermometer u (.clk(clk),.rst(rst),.temp_raw(temp_raw),.threshold(threshold),
                   .temp_display(temp_display),.alarm(alarm));
    int bad=0;
    initial begin
        rst=1;
        for (int i=0;i<2;i++) begin clk=0; #5; clk=1; #5; clk=0; #5; end
        rst=0; #5;
        // Below threshold
        temp_raw=8'd30; #5; if (alarm !== 0) begin bad++; $display("FAIL below"); end
        if (temp_display !== 8'd30) begin bad++; $display("FAIL display"); end
        // Above threshold
        temp_raw=8'd60; #5; if (alarm !== 1) begin bad++; $display("FAIL above"); end
        // Equal threshold
        temp_raw=8'd50; #5; if (alarm !== 0) begin bad++; $display("FAIL equal"); end
        if (bad==0) $display("EX_05 ALL TESTS PASS"); else $display("EX_05 FAIL: %0d", bad);
        $finish;
    end
endmodule
