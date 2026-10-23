`timescale 1ns/1ps
module tb_74174;
    logic clk=0, clr_n=1; logic [5:0] d, q;
    ic_74174 u(.clk(clk),.clr_n(clr_n),.d(d),.q(q));
    int bad=0;
    initial begin
        d=6'b101010; clk=0; #5; clk=1; #5; clk=0;
        if (q !== 6'b101010) begin bad++; $display("FAIL capture"); end
        d=6'b0; clk=1; #5; clk=0;
        if (q !== 6'b000000) begin bad++; $display("FAIL capture2: %b", q); end
        clr_n=0; #2; if (q !== 6'b0) begin bad++; $display("FAIL clear"); end
        if (bad==0) $display("74174 ALL TESTS PASS"); else $display("74174 FAIL: %0d", bad);
    end
endmodule
