`timescale 1ns/1ps
module tb;
    logic x,y,z;
    logic f_lab, f_prelab;
    func_exp5 u_lab (.x(x),.y(y),.z(z),.f(f_lab));
    func_prelab_q12 u_pre (.x(x),.y(y),.z(z),.f(f_prelab));
    int bad=0;
    // Lab Exp 5: f = Sigma(2,3,5,7) -> 0,0,1,1,0,1,0,1
    logic exp_lab [0:7] = '{0,0,1,1,0,1,0,1};
    // Prelab Q12: f = Sigma(0,3,4,7) -> 1,0,0,1,1,0,0,1
    logic exp_pre [0:7] = '{1,0,0,1,1,0,0,1};
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        for (int i=0;i<8;i++) begin
            {x,y,z}=i[2:0]; #1;
            if (f_lab !== exp_lab[i]) begin bad++; $display("FAIL lab %0d: got %b exp %b", i, f_lab, exp_lab[i]); end
            if (f_prelab !== exp_pre[i]) begin bad++; $display("FAIL prelab %0d: got %b exp %b", i, f_prelab, exp_pre[i]); end
        end
        if (bad==0) $display("EXP_5 ALL TESTS PASS"); else $display("EXP_5 FAIL: %0d", bad);
    end
endmodule
