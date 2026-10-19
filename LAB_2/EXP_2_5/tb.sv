`timescale 1ns/1ps
module tb;
    logic x = 1'b0, y = 1'b0, z = 1'b0;
    logic f;
    f_dec74ls138 u (.x(x), .y(y), .z(z), .f(f));

    int bad = 0;
    logic exp;

    // Table 2.6: f = Sigma(0,2,5,7) -> 1,0,1,0,0,1,0,1 for xyz 000..111
    function automatic logic expected(input logic x, y, z);
        case ({x,y,z})
            3'b000: return 1'b1;
            3'b001: return 1'b0;
            3'b010: return 1'b1;
            3'b011: return 1'b0;
            3'b100: return 1'b0;
            3'b101: return 1'b1;
            3'b110: return 1'b0;
            3'b111: return 1'b1;
        endcase
    endfunction

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");
        for (int v = 0; v < 8; v++) begin
            {x, y, z} = v[2:0];
            #1;
            exp = expected(x, y, z);
            if (f !== exp) bad++;
            $display("xyz=%b%b%b f=%b exp=%b %s", x, y, z, f, exp,
                     (f === exp) ? "OK" : "FAIL");
        end
        if (bad == 0) $display("ALL 8 TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
