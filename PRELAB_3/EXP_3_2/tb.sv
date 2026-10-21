`timescale 1ns/1ps
module tb;
    logic Sel = 1'b0;
    logic [3:0] A = 4'b0, B = 4'b0;
    logic [3:0] S_ic, S_fa;
    logic Cout_ic, Cout_fa;
    full_addsub_4bit u_ic (.Sel(Sel), .A(A), .B(B), .S(S_ic), .Cout(Cout_ic));
    addsub_4bit_fa   u_fa (.Sel(Sel), .A(A), .B(B), .S(S_fa), .Cout(Cout_fa));

    int bad = 0;
    int pair_a [12] = '{10,14,12,5,4,13,6,2,1,7,15,9};
    int pair_b [12] = '{11,10, 4,3,5,13,9,8,2,1, 6,15};
    int res;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");

        // 12 cặp toán hạng của Table 3.4, mỗi cặp ở cả 2 mode,
        // đồng thời kiểm tra bản dùng 74LS283 và bản dựng từ 4 khối Full Adder
        for (int i = 0; i < 12; i++) begin
            A = pair_a[i][3:0];
            B = pair_b[i][3:0];
            // Sel = 0 : cộng
            Sel = 1'b0; #1;
            res = pair_a[i] + pair_b[i];
            if (S_ic !== res[3:0] || Cout_ic !== (res > 15) ||
                S_fa !== res[3:0] || Cout_fa !== (res > 15)) begin
                bad++;
                $display("FAIL add %0d+%0d ic(S=%b C=%b) fa(S=%b C=%b)",
                         pair_a[i], pair_b[i], S_ic, Cout_ic, S_fa, Cout_fa);
            end else
                $display("ADD %0d+%0d = %0d (Cout=%b) OK", pair_a[i], pair_b[i], S_ic, Cout_ic);
            // Sel = 1 : trừ
            Sel = 1'b1; #1;
            res = pair_a[i] - pair_b[i];
            if (S_ic !== res[3:0] || Cout_ic !== (res >= 0) ||
                S_fa !== res[3:0] || Cout_fa !== (res >= 0)) begin
                bad++;
                $display("FAIL sub %0d-%0d ic(S=%b C=%b) fa(S=%b C=%b)",
                         pair_a[i], pair_b[i], S_ic, Cout_ic, S_fa, Cout_fa);
            end else
                $display("SUB %0d-%0d = %0d (Cout=%b) OK", pair_a[i], pair_b[i], S_ic, Cout_ic);
        end

        if (bad == 0) $display("ALL TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
