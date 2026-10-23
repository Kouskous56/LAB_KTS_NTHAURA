`timescale 1ns/1ps
module tb_74273;
    logic clk=0, clr_n=1; logic [7:0] d, q;
    ic_74273 u(.clk(clk),.clr_n(clr_n),.d(d),.q(q));
    int bad=0;
    initial begin
        d=8'hA5; clk=0; #5; clk=1; #5; clk=0;
        if (q !== 8'hA5) begin bad++; $display("FAIL capture"); end
        clr_n=0; #2; if (q !== 8'b0) begin bad++; $display("FAIL clear"); end
        if (bad==0) $display("74273 ALL TESTS PASS"); else $display("74273 FAIL: %0d", bad);
    end
endmodule
