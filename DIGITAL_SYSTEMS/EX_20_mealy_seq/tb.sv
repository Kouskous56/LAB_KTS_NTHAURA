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

        // Test 1: E=0, hold state
        E = 0; X = 1;
        tick();
        if (Z !== 0) begin bad++; $display("FAIL E=0: Z=%b", Z); end

        // Test 2: Detect "110" with E=1
        E = 1;
        // Reset
        rst=1; tick(); rst=0;
        // Input: 1,1,0
        X = 1; tick();  // state S1
        X = 1; tick();  // state S2
        X = 0; tick();  // should output Z=1 (matched "110")
        if (Z !== 1) begin bad++; $display("FAIL 110: Z=%b (exp 1)", Z); end

        // Test 3: Detect "1111" with E=1
        rst=1; tick(); rst=0;
        X = 1; tick();  // S1
        X = 1; tick();  // S2
        X = 1; tick();  // S4
        X = 1; tick();  // should output Z=1 (matched "1111")
        if (Z !== 1) begin bad++; $display("FAIL 1111: Z=%b (exp 1)", Z); end

        // Test 4: No false positive for "1110" (should detect "110" suffix)
        rst=1; tick(); rst=0;
        X = 1; tick();
        X = 1; tick();
        X = 1; tick();
        X = 0; tick();  // "1110" -> last 3 = "110" -> Z=1
        if (Z !== 1) begin bad++; $display("FAIL 1110: Z=%b (exp 1)", Z); end

        // Test 5: No match for "100"
        rst=1; tick(); rst=0;
        X = 1; tick();
        X = 0; tick();
        X = 0; tick();
        if (Z !== 0) begin bad++; $display("FAIL 100: Z=%b (exp 0)", Z); end

        if (bad == 0) $display("EX_20 ALL TESTS PASS");
        else          $display("EX_20 FAIL: %0d", bad);
        $finish;
    end
endmodule
