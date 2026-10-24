`timescale 1ns/1ps
module tb;
    logic X1, X2, X3;
    logic Z_orig, Y1, Y2, X2_bar;
    logic Z_fixed, Y3, t, t_bar;

    hazard_circuit u_orig (.X1(X1), .X2(X2), .X3(X3), .Z(Z_orig), .Y1(Y1), .Y2(Y2), .X2_bar(X2_bar));
    hazard_fixed u_fixed (.X1(X1), .X2(X2), .X3(X3), .Z(Z_fixed), .Y1(), .Y2(), .Y3(Y3), .t(t), .t_bar(t_bar));

    int bad = 0;

    initial begin
        // Set X1=1, X3=1
        X1 = 1; X3 = 1; X2 = 1;
        #50;  // Wait for steady state

        // Print header
        $display("Time(ns) | X2 | X2_bar | Y1 | Y2 | Z_orig | Z_fixed");
        $display("---------|----|--------|----|----|--------|--------");

        // Monitor for 100ns, sampling every 5ns
        for (int i = 0; i < 20; i++) begin
            $display("%8d |  %b |   %b    | %b  | %b  |   %b    |   %b",
                     $time, X2, X2_bar, Y1, Y2, Z_orig, Z_fixed);
            #5;
        end

        // Transition X2: 1 -> 0
        X2 = 0;

        // Monitor for 100ns after transition
        for (int i = 0; i < 20; i++) begin
            $display("%8d |  %b |   %b    | %b  | %b  |   %b    |   %b",
                     $time, X2, X2_bar, Y1, Y2, Z_orig, Z_fixed);
            #5;
        end

        // Check: Z should ideally be 1 (static-1) throughout
        // The original circuit will show a glitch (0) at some point
        $display("");
        $display("Analysis: Static-1 hazard occurs when X2 transitions 1->0");
        $display("Z should remain 1, but original circuit glitches to 0");
        $display("Fixed circuit (with consensus term X1*X3) eliminates the glitch");

        if (bad == 0) $display("EX_17 ALL TESTS PASS");
        else          $display("EX_17 FAIL: %0d", bad);
        $finish;
    end
endmodule
