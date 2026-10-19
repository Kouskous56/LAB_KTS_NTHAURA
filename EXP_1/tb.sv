`timescale 1ns/1ps
module tb;
    logic x, y, z;
    logic f0, f1;

    f_original   u0 (.x(x), .y(y), .z(z), .f(f0));
    f_simplified u1 (.x(x), .y(y), .z(z), .f(f1));

    int bad = 0;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");
        for (int v = 0; v < 8; v++) begin
            {z, y, x} = v[2:0];
            #1;
            $display("zyx=%b%b%b f_orig=%b f_simp=%b %s", z, y, x, f0, f1,
                     (f0 === f1) ? "OK" : "FAIL");
            if (f0 !== f1) bad++;
        end
        if (bad == 0) $display("ALL 8 TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
