`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1; logic tx_start=0; logic [7:0] tx_data=8'h00;
    logic tx, busy;
    uart_tx u (.clk(clk),.rst(rst),.tx_start(tx_start),.tx_data(tx_data),.tx(tx),.busy(busy));
    int bad=0;
    initial begin
        rst=1;
        for (int i=0;i<2;i++) begin clk=0; #5; clk=1; #5; clk=0; #5; end
        rst=0; #5;
        tx_data = 8'h55; tx_start = 1;
        clk=0; #5; clk=1; #5; clk=0; #5; tx_start=0;
        // Start bit
        if (tx !== 0) begin bad++; $display("FAIL start bit"); end
        // 8 data bits + 1 stop bit
        for (int i=0;i<10;i++) begin clk=0; #5; clk=1; #5; clk=0; #5; end
        if (busy !== 0) begin bad++; $display("FAIL busy"); end
        if (tx !== 1) begin bad++; $display("FAIL tx idle"); end
        if (bad==0) $display("EX_03 ALL TESTS PASS"); else $display("EX_03 FAIL: %0d", bad);
        $finish;
    end
endmodule
