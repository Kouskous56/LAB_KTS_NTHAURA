`timescale 1ns/1ps
module tb;
    logic Sel = 1'b0;
    logic [3:0] A = 4'b0, B = 4'b0;
    logic [3:0] S;
    logic Cout;
    full_addsub_4bit u (.Sel(Sel), .A(A), .B(B), .S(S), .Cout(Cout));

    int bad = 0;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");

        // Sel=0: addition
        Sel = 1'b0;
        A = 4'd5;  B = 4'd3;  #1;
        if (S !== 4'd8 || Cout !== 1'b0) begin bad++; $display("FAIL add 5+3"); end
        else $display("ADD 5+3 = %0d Cout=%b OK", S, Cout);

        A = 4'd9;  B = 4'd7;  #1;
        if (S !== 4'd0 || Cout !== 1'b1) begin bad++; $display("FAIL add 9+7"); end
        else $display("ADD 9+7 = %0d Cout=%b OK", S, Cout);

        A = 4'd0;  B = 4'd0;  #1;
        if (S !== 4'd0 || Cout !== 1'b0) begin bad++; $display("FAIL add 0+0"); end
        else $display("ADD 0+0 = %0d Cout=%b OK", S, Cout);

        // Sel=1: subtraction
        Sel = 1'b1;
        A = 4'd9;  B = 4'd3;  #1;
        if (S !== 4'd6 || Cout !== 1'b1) begin bad++; $display("FAIL sub 9-3"); end
        else $display("SUB 9-3 = %0d Cout=%b OK", S, Cout);

        A = 4'd3;  B = 4'd9;  #1;
        if (S !== 4'd10 || Cout !== 1'b0) begin bad++; $display("FAIL sub 3-9"); end
        else $display("SUB 3-9 = %0d Cout=%b OK", S, Cout);

        A = 4'd7;  B = 4'd7;  #1;
        if (S !== 4'd0 || Cout !== 1'b1) begin bad++; $display("FAIL sub 7-7"); end
        else $display("SUB 7-7 = %0d Cout=%b OK", S, Cout);

        A = 4'd0;  B = 4'd1;  #1;
        if (S !== 4'd15 || Cout !== 1'b0) begin bad++; $display("FAIL sub 0-1"); end
        else $display("SUB 0-1 = %0d Cout=%b OK", S, Cout);

        if (bad == 0) $display("ALL TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
