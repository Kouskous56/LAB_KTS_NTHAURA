`timescale 1ns/1ps
module tb;
    logic [2:0] din, dout; logic valid;
    dec_enc_pair u (.din(din),.dout(dout),.valid(valid));
    int bad=0;
    initial begin
        for (int i=0;i<8;i++) begin
            din = i[2:0]; #1;
            if (dout !== din) begin bad++; $display("FAIL roundtrip: in=%0d out=%0d", din, dout); end
            if (valid !== 1) begin bad++; $display("FAIL valid"); end
        end
        if (bad==0) $display("EX_09 ALL TESTS PASS"); else $display("EX_09 FAIL: %0d", bad);
    end
endmodule
