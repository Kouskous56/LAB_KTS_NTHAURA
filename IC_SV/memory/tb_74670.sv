`timescale 1ns/1ps
module tb_74670;
    logic [1:0] wa, ra, rb; logic [3:0] din, qa, qb; logic we_n;
    ic_74670 u (.wa(wa),.ra(ra),.rb(rb),.din(din),.we_n(we_n),.qa(qa),.qb(qb));
    int bad=0;
    initial begin
        // write 0xA to addr 1
        wa=2'd1; din=4'hA; we_n=0; #5; we_n=1; #5;
        // write 0x5 to addr 2
        wa=2'd2; din=4'h5; we_n=0; #5; we_n=1; #5;
        // read both
        ra=2'd1; rb=2'd2; #5;
        if (qa !== 4'hA || qb !== 4'h5) begin bad++; $display("FAIL read: qa=%h qb=%h", qa, qb); end
        // write while reading different addr
        wa=2'd3; din=4'hF; we_n=0; #5; we_n=1; #5;
        ra=2'd3; #5;
        if (qa !== 4'hF) begin bad++; $display("FAIL read3"); end
        if (bad==0) $display("74670 ALL TESTS PASS"); else $display("74670 FAIL: %0d", bad);
    end
endmodule
