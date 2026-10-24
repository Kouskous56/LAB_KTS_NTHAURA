`timescale 1ns/1ps
module tb;
    logic clk=0;
    logic rst_n=1;
    logic preset=0;
    logic [2:0] Q;
    logic [2:0] exp;

    counter_sr u (.clk(clk), .rst_n(rst_n), .preset(preset), .Q(Q));

    int bad = 0;
    logic [2:0] expected_seq [0:4] = '{3'b000, 3'b111, 3'b110, 3'b101, 3'b001};

    initial begin
        #5; rst_n = 0; #20; rst_n = 1; #10;
        $display("INIT: Q=%b", Q);
        if (Q !== 3'b000) begin bad++; $display("FAIL init: %b", Q); end

        for (int i = 0; i < 5; i++) begin
            clk = 1; #5; clk = 0; #5;
            exp = expected_seq[(i+1) % 5];
            $display("Step %0d: Q=%b exp=%b", i, Q, exp);
            if (Q !== exp) begin
                bad++;
            end
        end

        if (bad == 0) $display("EX_18 ALL TESTS PASS");
        else          $display("EX_18 FAIL: %0d", bad);
        $finish;
    end
endmodule
