`timescale 1ns/1ps
module tb;
    logic [3:0] x;
    logic [2:0] y;
    logic s_temp;
    logic [2:0] b_temp;
    logic [2:0] expected;

    cau_2 u (.x(x), .y(y), .s_temp(s_temp), .b_temp(b_temp));

    int bad = 0;

    initial begin
        for (int i = 0; i < 16; i++) begin
            x = i[3:0];
            #10;
            expected = (s_temp == 0) ? x[2:0] : 3'b000;
            if (y !== expected) begin
                bad++;
                $display("FAIL: x=%b s=%b expected %b got %b", x, s_temp, expected, y);
            end
        end
        if (bad == 0) $display("EX_15 ALL TESTS PASS");
        else          $display("EX_15 FAIL: %0d", bad);
        $finish;
    end
endmodule
