`timescale 1ns/1ps
module tb;
    logic w, x, y, z;
    logic f;
    func_from_fa u (.w(w), .x(x), .y(y), .z(z), .f(f));

    int bad = 0;
    logic expected;

    initial begin
        for (int i = 0; i < 16; i++) begin
            w = i[3]; x = i[2]; y = i[1]; z = i[0];
            #10;
            // Expected: f = w OR (x AND y AND z)
            expected = w | (x & y & z);
            if (f !== expected) begin
                bad++;
                $display("FAIL: w=%b x=%b y=%b z=%b => f=%b (exp %b)", w, x, y, z, f, expected);
            end
        end
        if (bad == 0) $display("EX_13 ALL TESTS PASS");
        else          $display("EX_13 FAIL: %0d", bad);
        $finish;
    end
endmodule
