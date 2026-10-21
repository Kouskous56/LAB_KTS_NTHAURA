`timescale 1ns/1ps
module tb;
    logic clk = 1'b0, clr = 1'b1;
    logic A = 1'b1, B = 1'b1;
    logic [2:0] Q;
    counter_0_7 u (.clk(clk), .clr(clr), .A(A), .B(B), .Q(Q));

    int bad = 0;

    task automatic tick;
        begin
            #1 clk = 1'b1; #1 clk = 1'b0; #1;
        end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");

        // A=0, B=1 : LSB frozen -> count does not advance
        A = 1'b0; B = 1'b1;
        clr = 1'b0; #1; clr = 1'b1; #1;
        for (int i = 0; i < 4; i++) tick();
        if (Q !== 3'b000) begin bad++; $display("FAIL A=0,B=1 Q=%b", Q); end
        else $display("A=0,B=1 -> Q=%b (frozen) OK", Q);

        // A=1, B=0 : only LSB toggles
        A = 1'b1; B = 1'b0;
        clr = 1'b0; #1; clr = 1'b1; #1;
        tick();
        if (Q !== 3'b001) begin bad++; $display("FAIL A=1,B=0 step1 Q=%b", Q); end
        else $display("A=1,B=0 -> Q=%b OK", Q);
        tick();
        if (Q !== 3'b000) begin bad++; $display("FAIL A=1,B=0 step2 Q=%b", Q); end
        else $display("A=1,B=0 -> Q=%b OK", Q);

        // A=B=1 : full 0..7 then wrap
        A = 1'b1; B = 1'b1;
        clr = 1'b0; #1; clr = 1'b1; #1;
        for (int i = 1; i <= 8; i++) begin
            tick();
            if (Q !== i[2:0]) begin
                bad++;
                $display("FAIL count %0d Q=%b", i, Q);
            end else
                $display("count %0d Q=%b OK", i, Q);
        end

        if (bad == 0) $display("ALL TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
