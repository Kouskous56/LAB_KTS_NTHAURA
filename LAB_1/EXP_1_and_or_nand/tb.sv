`timescale 1ns/1ps
module tb;
    logic x,y,z; logic f_andor, f_nand;
    func_and_or u1 (.x(x),.y(y),.z(z),.f(f_andor));
    func_nand  u2 (.x(x),.y(y),.z(z),.f(f_nand));
    int bad=0;
    logic exp;
    initial begin
        $dumpfile("wave.vcd"); $dumpvars(0, tb);
        for (int i=0;i<8;i++) begin
            {x,y,z} = i[2:0];
            #1;
            exp = (~x & y) | (~y & z);
            if (f_andor !== exp) begin bad++; $display("FAIL andor %0d", i); end
            if (f_nand  !== exp) begin bad++; $display("FAIL nand %0d", i); end
            if (f_andor !== f_nand) begin bad++; $display("FAIL mismatch %0d", i); end
        end
        if (bad==0) $display("EXP_1 ALL TESTS PASS"); else $display("EXP_1 FAIL: %0d", bad);
    end
endmodule
