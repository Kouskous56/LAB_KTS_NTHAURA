`timescale 1ns/1ps
module tb;
    logic [3:0] A, B;
    logic S1, S0;
    logic [3:0] F;
    logic Cout;

    arithmetic_unit u (.A(A), .B(B), .S1(S1), .S0(S0), .F(F), .Cout(Cout));

    int bad = 0;

    task automatic check(input logic [3:0] a, b, input logic s1, s0, input logic [3:0] exp_f, input logic exp_cout);
        A = a; B = b; S1 = s1; S0 = s0;
        #10;
        if (F !== exp_f || Cout !== exp_cout) begin
            bad++;
            $display("FAIL: A=%b B=%b S1S0=%b%b => F=%b Cout=%b (exp F=%b Cout=%b)",
                     a, b, s1, s0, F, Cout, exp_f, exp_cout);
        end
    endtask

    initial begin
        // Test A+B (S1S0=00)
        check(4'b0011, 4'b0101, 0, 0, 4'b1000, 0);  // 3+5=8
        check(4'b1111, 4'b0001, 0, 0, 4'b0000, 1);  // 15+1=16 (overflow)
        check(4'b0000, 4'b0000, 0, 0, 4'b0000, 0);  // 0+0=0

        // Test A+1 (S1S0=01)
        check(4'b0011, 4'b0000, 0, 1, 4'b0100, 0);  // 3+1=4
        check(4'b1111, 4'b0000, 0, 1, 4'b0000, 1);  // 15+1=16 (overflow)

        // Test A-B (S1S0=10)
        check(4'b0101, 4'b0011, 1, 0, 4'b0010, 1);  // 5-3=2
        check(4'b0011, 4'b0101, 1, 0, 4'b1110, 0);  // 3-5=-2 (two's complement)

        // Test A-B-1 (S1S0=11)
        check(4'b0101, 4'b0011, 1, 1, 4'b0001, 1);  // 5-3-1=1
        check(4'b0011, 4'b0011, 1, 1, 4'b1111, 0);  // 3-3-1=-1

        if (bad == 0) $display("EX_11 ALL TESTS PASS");
        else          $display("EX_11 FAIL: %0d", bad);
        $finish;
    end
endmodule
