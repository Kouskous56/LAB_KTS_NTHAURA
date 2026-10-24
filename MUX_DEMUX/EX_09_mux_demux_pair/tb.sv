`timescale 1ns/1ps
module tb;
    logic [3:0] din, dout; logic [1:0] sel_mux, sel_demux; logic routed;
    mux_demux_pair u (.din(din),.sel_mux(sel_mux),.sel_demux(sel_demux),.dout(dout),.routed(routed));
    int bad=0;
    initial begin
        din = 4'b1010;
        // Route din[2] to dout[1]
        sel_mux = 2'd3; sel_demux = 2'd1; #1;
        if (dout !== 4'b0010) begin bad++; $display("FAIL route: got %b", dout); end
        // Route din[0] to dout[3]
        sel_mux = 2'd1; sel_demux = 2'd3; #1;
        if (dout !== 4'b1000) begin bad++; $display("FAIL route2: got %b", dout); end
        // routed should equal selected input
        if (routed !== din[sel_mux]) begin bad++; $display("FAIL routed"); end
        if (bad==0) $display("EX_09 ALL TESTS PASS"); else $display("EX_09 FAIL: %0d", bad);
    end
endmodule
