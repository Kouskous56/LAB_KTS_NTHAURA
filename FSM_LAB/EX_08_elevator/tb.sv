`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1; logic [2:0] request=3'b000;
    logic [1:0] floor; logic up, down, idle;
    elevator u (.clk(clk),.rst(rst),.request(request),.floor(floor),.up(up),.down(down),.idle(idle));
    int bad=0;
    initial begin
        rst=1;
        for (int i=0;i<2;i++) begin clk=0; #5; clk=1; #5; clk=0; #5; end
        rst=0; #5;
        // Start at floor 0
        if (floor !== 2'd0) begin bad++; $display("FAIL init floor"); end
        // Request floor 2
        request = 3'b100; clk=0; #5; clk=1; #5; clk=0; #5;
        if (floor !== 2'd1) begin bad++; $display("FAIL floor1: %0d", floor); end
        clk=0; #5; clk=1; #5; clk=0; #5;
        if (floor !== 2'd2) begin bad++; $display("FAIL floor2: %0d", floor); end
        // Request floor 0
        request = 3'b001; clk=0; #5; clk=1; #5; clk=0; #5;
        if (floor !== 2'd1) begin bad++; $display("FAIL down1: %0d", floor); end
        if (bad==0) $display("EX_08 ALL TESTS PASS"); else $display("EX_08 FAIL: %0d", bad);
        $finish;
    end
endmodule
