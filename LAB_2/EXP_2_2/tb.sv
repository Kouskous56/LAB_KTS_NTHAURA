`timescale 1ns/1ps
module tb;
    logic X = 1'b0, Y = 1'b0, Z = 1'b0;
    logic F;
    f_exp2_2 u (.X(X), .Y(Y), .Z(Z), .F(F));

    int bad = 0;
    logic exp;

    // truth table from Table 2.3
    function automatic logic expected(input logic x, y, z);
        case ({x,y,z})
            3'b000: return 1'b1;
            3'b001: return 1'b1;
            3'b010: return 1'b0;
            3'b011: return 1'b1;
            3'b100: return 1'b1;
            3'b101: return 1'b0;
            3'b110: return 1'b0;
            3'b111: return 1'b1;
        endcase
    endfunction

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");
        for (int v = 0; v < 8; v++) begin
            {X, Y, Z} = v[2:0];
            exp = expected(X, Y, Z);
            #1;
            if (F !== exp) bad++;
            $display("XYZ=%b%b%b F=%b exp=%b %s", X, Y, Z, F, exp,
                     (F === exp) ? "OK" : "FAIL");
        end
        if (bad == 0) $display("ALL 8 TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
