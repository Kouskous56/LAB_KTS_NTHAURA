`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1;
    logic E=0, X=0;
    logic Z;

    mealy_seq u (.clk(clk), .rst(rst), .E(E), .X(X), .Z(Z));

    int bad = 0;

    task automatic tick();
        clk=0; #5; clk=1; #5; clk=0; #5;
    endtask

    initial begin
        rst=1; tick(); rst=0;

        // Test 1: E=0, hold state, Z=0
        E = 0; X = 1;
        tick();
        if (Z !== 0) begin bad++; $display("FAIL E=0: Z=%b", Z); end

        // Test 2: Detect "110" with E=1
        // Z is Mealy: check before clock edge
        E = 1;
        rst=1; tick(); rst=0;
        X = 1; tick();  // after tick, state=S1, but Z during transition was 0
        // Check Z after applying next input but before clock
        X = 1; #1;  // state still S1, X=1 -> Z=0 (not complete yet)
        // Actually, Z = f(state, X). State is S1, X=1 -> Z=0. Correct.
        clk=0; #5; clk=1; #5; clk=0; #5;  // clock -> state S2
        X = 0; #1;  // state S2, X=0 -> Z=1 (matched "110")
        if (Z !== 1) begin bad++; $display("FAIL 110: Z=%b (exp 1)", Z); end
        clk=0; #5; clk=1; #5; clk=0; #5;

        // Test 3: Detect "1111" with E=1
        rst=1; tick(); rst=0;
        X = 1; clk=0; #5; clk=1; #5; clk=0; #5;  // S1
        X = 1; clk=0; #5; clk=1; #5; clk=0; #5;  // S2
        X = 1; #1;  // state S2, X=1 -> Z=0 (not complete)
        clk=0; #5; clk=1; #5; clk=0; #5;  // S4
        X = 1; #1;  // state S4, X=1 -> Z=1 (matched "1111")
        if (Z !== 1) begin bad++; $display("FAIL 1111: Z=%b (exp 1)", Z); end
        clk=0; #5; clk=1; #5; clk=0; #5;

        // Test 4: "1110" -> Z=1 (suffix "110")
        rst=1; tick(); rst=0;
        X = 1; clk=0; #5; clk=1; #5; clk=0; #5;
        X = 1; clk=0; #5; clk=1; #5; clk=0; #5;
        X = 1; clk=0; #5; clk=1; #5; clk=0; #5;
        X = 0; #1;  // state S4, X=0 -> Z=1 (matched "110" suffix)
        if (Z !== 1) begin bad++; $display("FAIL 1110: Z=%b (exp 1)", Z); end
        clk=0; #5; clk=1; #5; clk=0; #5;

        // Test 5: No match for "100"
        rst=1; tick(); rst=0;
        X = 1; clk=0; #5; clk=1; #5; clk=0; #5;
        X = 0; #1;  // state S1, X=0 -> Z=0
        if (Z !== 0) begin bad++; $display("FAIL 100a: Z=%b (exp 0)", Z); end
        clk=0; #5; clk=1; #5; clk=0; #5;
        X = 0; #1;  // state S0, X=0 -> Z=0
        if (Z !== 0) begin bad++; $display("FAIL 100b: Z=%b (exp 0)", Z); end
        clk=0; #5; clk=1; #5; clk=0; #5;

        if (bad == 0) $display("EX_20 ALL TESTS PASS");
        else          $display("EX_20 FAIL: %0d", bad);
        $finish;
    end
endmodule
