`timescale 1ns/1ps
module tb_74377;
    logic clk=0; logic ce_n=1; logic [7:0] d, q;
    ic_74377 u(.clk(clk),.ce_n(ce_n),.d(d),.q(q));
    int bad=0;
    initial begin
        d=8'hA5; ce_n=0; clk=0; #5; clk=1; #5; clk=0;
        if (q !== 8'hA5) begin bad++; $display("FAIL capture"); end
        d=8'h00; ce_n=1; clk=1; #5; clk=0;
        if (q !== 8'hA5) begin bad++; $display("FAIL hold: %b", q); end
        ce_n=0; clk=1; #5; clk=0;
        if (q !== 8'h00) begin bad++; $display("FAIL capture2"); end
        if (bad==0) $display("74377 ALL TESTS PASS"); else $display("74377 FAIL: %0d", bad);
    end
endmodule
