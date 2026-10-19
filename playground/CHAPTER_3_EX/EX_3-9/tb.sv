`timescale 1ns/1ps
module tb;
    logic [3:0] xs3, bin;
    xs3_to_bin u (.xs3(xs3), .bin(bin));

    int bad = 0;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");
        // xs3 = decimal + 3 ; valid codes 0011..1100
        for (int d = 0; d < 10; d++) begin
            xs3 = d + 3;
            #1;
            if (bin !== d[3:0]) begin
                bad++;
                $display("FAIL xs3=%b bin=%b exp=%0d", xs3, bin, d);
            end else
                $display("xs3=%b (%0d+3) -> bin=%b (%0d) OK", xs3, d, bin, d);
        end
        if (bad == 0) $display("ALL 10 TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
