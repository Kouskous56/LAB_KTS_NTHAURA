`timescale 1ns/1ps
module tb;
    logic A, B, C, D;
    logic F_a, F_b, F_c;
    logic expected;

    func_f_part_a u_a (.A(A), .B(B), .C(C), .D(D), .F(F_a));
    func_f_part_b u_b (.A(A), .B(B), .C(C), .D(D), .F(F_b));
    func_f_part_c u_c (.A(A), .B(B), .C(C), .D(D), .F(F_c));

    int bad = 0;

    initial begin
        for (int i = 0; i < 16; i++) begin
            A = i[3]; B = i[2]; C = i[1]; D = i[0];
            #10;
            expected = (A & (B ^ C)) | (B & C & D);
            if (F_a !== expected) begin bad++; $display("FAIL part_a: ABCD=%b%b%b%b F=%b exp=%b", A, B, C, D, F_a, expected); end
            if (F_b !== expected) begin bad++; $display("FAIL part_b: ABCD=%b%b%b%b F=%b exp=%b", A, B, C, D, F_b, expected); end
            if (F_c !== expected) begin bad++; $display("FAIL part_c: ABCD=%b%b%b%b F=%b exp=%b", A, B, C, D, F_c, expected); end
        end
        if (bad == 0) $display("EX_16 ALL TESTS PASS");
        else          $display("EX_16 FAIL: %0d", bad);
        $finish;
    end
endmodule
