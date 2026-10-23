`timescale 1ns/1ps
module tb_74595;
    logic clk=0, rclk=0, oe_n=0, srclr_n=1, ser=0; logic [7:0] q;
    ic_74595 u(.clk(clk),.rclk(rclk),.oe_n(oe_n),.srclr_n(srclr_n),.ser(ser),.q(q));
    int bad=0;
    logic bits [0:7];
    task automatic clkp(); clk=0; #5; clk=1; #5; clk=0; #5; endtask
    task automatic rlatch(); rclk=0; #5; rclk=1; #5; rclk=0; #5; endtask
    initial begin
        srclr_n=0; #2; srclr_n=1; #2;
        // shift in 10101010
        bits = '{1,0,1,0,1,0,1,0};
        for (int i=0;i<8;i++) begin ser=bits[i]; clkp(); end
        // latch
        rlatch();
        if (q !== 8'b10101010) begin bad++; $display("FAIL latch: %b", q); end
        // OE disable
        oe_n=1; #5; if (q !== 8'bz) begin bad++; $display("FAIL OE"); end
        oe_n=0;
        if (bad==0) $display("74595 ALL TESTS PASS"); else $display("74595 FAIL: %0d", bad);
    end
endmodule
