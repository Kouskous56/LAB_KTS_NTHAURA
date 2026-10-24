`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1, x=0; logic [1:0] state_out; logic z;
    param_fsm #(4) u (.clk(clk),.rst(rst),.x(x),.state_out(state_out),.z(z));
    int bad=0;
    initial begin
        rst=1; #10; rst=0; #5;
        // x=0: stay at 0
        x=0; clk=0; #5; clk=1; #5; clk=0; #5;
        if (state_out !== 0 || z !== 0) begin bad++; $display("FAIL hold"); end
        // x=1: advance through states
        x=1;
        for (int i=1;i<4;i++) begin
            clk=0; #5; clk=1; #5; clk=0; #5;
            if (state_out !== i[1:0]) begin bad++; $display("FAIL state %0d: got %0d", i, state_out); end
        end
        // Last state: z=1
        if (z !== 1) begin bad++; $display("FAIL z at last state"); end
        // Wrap around
        clk=0; #5; clk=1; #5; clk=0; #5;
        if (state_out !== 0) begin bad++; $display("FAIL wrap"); end
        if (bad==0) $display("EX_10 ALL TESTS PASS"); else $display("EX_10 FAIL: %0d", bad);
    end
endmodule
