`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1; logic tx_start=0; logic [7:0] tx_data=8'h00;
    logic tx, busy;
    uart_fsm u (.clk(clk),.rst(rst),.tx_start(tx_start),.tx_data(tx_data),.tx(tx),.busy(busy));
    int bad=0;
    initial begin
        rst=1; #10; rst=0; #5;
        // Send 0x55 (01010101)
        tx_data = 8'h55; tx_start = 1;
        clk=0; #5; clk=1; #5; clk=0; #5; tx_start=0;
        // Check start bit
        if (tx !== 0) begin bad++; $display("FAIL start bit"); end
        // 8 data bits + stop bit = 9 more clocks
        for (int i=0;i<9;i++) begin clk=0; #5; clk=1; #5; clk=0; #5; end
        if (busy !== 0) begin bad++; $display("FAIL busy not cleared"); end
        if (tx !== 1) begin bad++; $display("FAIL tx not idle"); end
        if (bad==0) $display("EX_09 ALL TESTS PASS"); else $display("EX_09 FAIL: %0d", bad);
    end
endmodule
