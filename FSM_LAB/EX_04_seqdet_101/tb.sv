`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1, x=0, z;
    fsm_seqdet_101 u (.clk(clk),.rst(rst),.x(x),.z(z));
    int bad=0;
    logic seq [0:7] = '{1,0,1,0,1,1,0,1};
    logic exp_z [0:7] = '{0,0,1,0,1,0,0,1};
    initial begin
        rst=1; for (int i=0;i<2;i++) begin clk=0; #5; clk=1; #5; clk=0; #5; end
        rst=0; #5;
        for (int i=0;i<8;i++) begin
            x = seq[i]; #10;
            if (z !== exp_z[i]) begin bad++; $display("FAIL step %0d: x=%b z=%b (exp %b)", i, x, z, exp_z[i]); end
            clk=0; #5; clk=1; #5; clk=0; #5;
        end
        if (bad==0) $display("EX_04 ALL TESTS PASS"); else $display("EX_04 FAIL: %0d", bad);
    end
endmodule
