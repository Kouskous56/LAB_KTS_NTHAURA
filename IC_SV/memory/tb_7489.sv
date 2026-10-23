`timescale 1ns/1ps
module tb_7489;
    logic [3:0] addr, din, dout; logic we_n, oe_n;
    ic_7489 u (.addr(addr),.din(din),.we_n(we_n),.oe_n(oe_n),.dout(dout));
    int bad=0;
    initial begin
        // write 0xA to address 3
        addr=4'd3; din=4'hA; we_n=0; oe_n=1; #5; we_n=1; #5;
        // read back (inverted output)
        addr=4'd3; oe_n=0; #5;
        if (dout !== ~4'hA) begin bad++; $display("FAIL read: %b (exp %b)", dout, ~4'hA); end
        // write another
        addr=4'd7; din=4'h5; we_n=0; oe_n=1; #5; we_n=1; #5;
        addr=4'd7; oe_n=0; #5;
        if (dout !== ~4'h5) begin bad++; $display("FAIL read2"); end
        // disabled output
        oe_n=1; #5;
        if (dout !== 4'bz) begin bad++; $display("FAIL OE"); end
        if (bad==0) $display("7489 ALL TESTS PASS"); else $display("7489 FAIL: %0d", bad);
    end
endmodule
