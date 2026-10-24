`timescale 1ns/1ps
module tb;
    // Test 4-to-1 MUX
    logic [3:0] d4; logic [1:0] sel4; logic y4;
    mux_param #(4) mux4 (.d(d4),.sel(sel4),.y(y4));
    // Test 8-to-1 MUX
    logic [7:0] d8; logic [2:0] sel8; logic y8;
    mux_param #(8) mux8 (.d(d8),.sel(sel8),.y(y8));
    // Test 4-to-1 DEMUX
    logic d_demux; logic [1:0] sel_demux; logic [3:0] y_demux;
    demux_param #(4) demux4 (.d(d_demux),.sel(sel_demux),.y(y_demux));
    int bad=0;
    logic [3:0] exp;
    initial begin
        d4 = 4'b1010; d8 = 8'b10101010;
        for (int i=0;i<4;i++) begin sel4=i[1:0]; #1; if (y4 !== d4[sel4]) begin bad++; $display("FAIL mux4"); end end
        for (int i=0;i<8;i++) begin sel8=i[2:0]; #1; if (y8 !== d8[sel8]) begin bad++; $display("FAIL mux8"); end end
        d_demux = 1'b1;
        for (int i=0;i<4;i++) begin sel_demux=i[1:0]; #1; exp=4'b0; exp[sel_demux]=1'b1; if (y_demux !== exp) begin bad++; $display("FAIL demux4"); end end
        if (bad==0) $display("EX_10 ALL TESTS PASS"); else $display("EX_10 FAIL: %0d", bad);
    end
endmodule
