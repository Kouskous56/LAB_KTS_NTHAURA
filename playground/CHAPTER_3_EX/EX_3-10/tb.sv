`timescale 1ns/1ps
module tb;
    logic [7:0] bcd;
    logic [6:0] bin;
    bcd2bin u (.bcd(bcd), .bin(bin));

    int bad = 0;
    int exp;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");
        for (int tens = 0; tens < 10; tens++)
            for (int units = 0; units < 10; units++) begin
                bcd = {tens[3:0], units[3:0]};
                #1;
                exp = 10*tens + units;
                if (bin !== exp[6:0]) begin
                    bad++;
                    if (bad < 6) $display("FAIL bcd=%b bin=%b exp=%0d", bcd, bin, exp);
                end
            end
        if (bad == 0) $display("ALL 100 TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
