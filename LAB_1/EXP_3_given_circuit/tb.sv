`timescale 1ns/1ps
module tb;
    logic x,y,z; logic f1,f2;
    func_f1 u1 (.x(x),.y(y),.z(z),.f(f1));
    func_f2 u2 (.x(x),.y(y),.z(z),.f(f2));
    int bad=0;
    // Table 1.3 expected: 0,1,1,1,0,1,0,1
    logic exp_tab [0:7] = '{0,1,1,1,0,1,0,1};
    initial begin
        $dumpfile("wave.vcd"); $dumpvars(0, tb);
        for (int i=0;i<8;i++) begin
            {x,y,z}=i[2:0]; #1;
            if (f1 !== exp_tab[i]) begin bad++; $display("FAIL F1 %0d", i); end
            if (f2 !== exp_tab[i]) begin bad++; $display("FAIL F2 %0d", i); end
            if (f1 !== f2) begin bad++; $display("FAIL mismatch %0d", i); end
        end
        if (bad==0) $display("EXP_3 ALL TESTS PASS"); else $display("EXP_3 FAIL: %0d", bad);
    end
endmodule
