`timescale 1ns/1ps
module tb_7400;
    logic [3:0] a, b, y;
    ic_7400 u (.a(a), .b(b), .y(y));
    int bad = 0;
    initial begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                a = i[3:0]; b = j[3:0]; #1;
                if (y !== ~(a & b)) begin bad++; if (bad<=5) $display("FAIL"); end
            end
        end
        if (bad == 0) $display("7400 ALL TESTS PASS");
        else $display("7400 FAIL: %0d", bad);
    end
endmodule
