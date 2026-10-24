`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1, x=0, z;
    fsm_seqdet_1101 u (.clk(clk),.rst(rst),.x(x),.z(z));
    int bad=0;
    // Sequence: 1 1 0 1 1 0 1
    // z=1 when "1101" detected (Moore: z=1 on the last bit, delayed 1 clock)
    logic seq [0:6] = '{1,1,0,1,1,0,1};
    logic exp_z [0:6] = '{0,0,0,1,0,0,1};  // Moore: z delayed 1 clock
    initial begin
        rst=1; for (int i=0;i<2;i++) begin clk=0; #5; clk=1; #5; clk=0; #5; end
        rst=0; #5;
        for (int i=0;i<7;i++) begin
            x = seq[i]; clk=0; #5; clk=1; #5; clk=0; #5;
            if (z !== exp_z[i]) begin bad++; $display("FAIL step %0d: x=%b z=%b (exp %b)", i, x, z, exp_z[i]); end
        end
        if (bad==0) $display("EX_05 ALL TESTS PASS"); else $display("EX_05 FAIL: %0d", bad);
    end
endmodule
