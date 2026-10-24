`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1; logic [3:0] request=4'b0000;
    logic [1:0] floor; logic up, down, door_open, idle;
    elevator_adv u (.clk(clk),.rst(rst),.request(request),.floor(floor),.up(up),.down(down),.door_open(door_open),.idle(idle));
    int bad=0;
    initial begin
        rst=1;
        for (int i=0;i<2;i++) begin clk=0; #5; clk=1; #5; clk=0; #5; end
        rst=0; #5;
        if (floor !== 2'd0) begin bad++; $display("FAIL init"); end
        request = 4'b1000; // floor 3
        clk=0; #5; clk=1; #5; clk=0; #5;
        if (floor !== 2'd1) begin bad++; $display("FAIL up1"); end
        clk=0; #5; clk=1; #5; clk=0; #5;
        if (floor !== 2'd2) begin bad++; $display("FAIL up2"); end
        clk=0; #5; clk=1; #5; clk=0; #5;
        if (floor !== 2'd3) begin bad++; $display("FAIL up3"); end
        if (bad==0) $display("EX_09 ALL TESTS PASS"); else $display("EX_09 FAIL: %0d", bad);
        $finish;
    end
endmodule
