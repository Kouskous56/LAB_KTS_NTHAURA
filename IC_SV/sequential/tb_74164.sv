`timescale 1ns/1ps
module tb_74164;
    logic clk=0, clr_n=1; logic a=1, b=1; logic [7:0] q;
    ic_74164 u (.clk(clk),.clr_n(clr_n),.a(a),.b(b),.q(q));
    int bad=0;
    logic bits [0:7];
    task automatic clkp(); clk=0; #5; clk=1; #5; clk=0; #5; endtask
    initial begin
        bits = '{1,0,1,1,0,0,0,1};
        clr_n=0; #2; clr_n=1; #2; if (q!==8'b0) begin bad++; $display("FAIL clear"); end
        // shift in 1,0,1,1,0,0,0,1
        for (int i=0;i<8;i++) begin a=bits[i]; b=1; clkp(); end
        if (q !== 8'b10110001) begin bad++; $display("FAIL shift: %b", q); end
        if (bad==0) $display("74164 ALL TESTS PASS"); else $display("74164 FAIL: %0d", bad);
    end
endmodule
