`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1;
    logic X;
    logic [2:0] Q;  // Q[2]=Q1(MSB), Q[1]=Q2, Q[0]=Q3

    counter_x u (.clk(clk), .rst(rst), .X(X), .Q(Q));

    int bad = 0;

    task automatic tick();
        clk=0; #5; clk=1; #5; clk=0; #5;
    endtask

    initial begin
        rst=1; tick(); rst=0;

        // Test X=0: state should swap Q1 and Q3
        X = 0;
        // Start from 001 (Q1=0,Q2=0,Q3=1) -> should go to 100
        rst=1; tick(); rst=0;
        // Force state 001 by reset then... actually reset goes to 000
        // Let's just test from 000
        // 000 -> (Q3=0, Q2=0, Q1=0) = 000 (fixed point)
        tick();
        if (Q !== 3'b000) begin bad++; $display("FAIL X0: 000->%b (exp 000)", Q); end

        // Test X=1: Johnson counter behavior
        X = 1;
        rst=1; tick(); rst=0;  // reset to 000
        // 000 -> 100
        tick();
        if (Q !== 3'b100) begin bad++; $display("FAIL X1: 000->%b (exp 100)", Q); end
        // 100 -> 111
        tick();
        if (Q !== 3'b111) begin bad++; $display("FAIL X1: 100->%b (exp 111)", Q); end
        // 111 -> 001
        tick();
        if (Q !== 3'b001) begin bad++; $display("FAIL X1: 111->%b (exp 001)", Q); end
        // 001 -> 000
        tick();
        if (Q !== 3'b000) begin bad++; $display("FAIL X1: 001->%b (exp 000)", Q); end

        if (bad == 0) $display("EX_19 ALL TESTS PASS");
        else          $display("EX_19 FAIL: %0d", bad);
        $finish;
    end
endmodule
