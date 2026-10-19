`timescale 1ns/1ps
module tb;
    logic x, y, z;
    logic f;

    f_exp2_1 u (.x(x), .y(y), .z(z), .f(f));

    int bad = 0;
    logic exp;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");
        // expected truth table of f = x'yz + (xy)'z + xy
        for (int v = 0; v < 8; v++) begin
            {z, y, x} = v[2:0];
            #1;
            // expected: f = xy + z
            exp = (x & y) | z;
            if (f !== exp) bad++;
            $display("zyx=%b%b%b f=%b exp=%b %s", z, y, x, f, exp,
                     (f === exp) ? "OK" : "FAIL");
        end
        if (bad == 0) $display("ALL 8 TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
