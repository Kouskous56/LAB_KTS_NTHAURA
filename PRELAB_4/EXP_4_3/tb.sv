`timescale 1ns/1ps
module tb;
    logic [3:0] I;
    logic [6:0] out;
    bcd7seg u (.I(I), .out(out));
    int bad = 0;
    function automatic logic [6:0] exp_pat(input logic [3:0] v);
        case (v)
            4'h0: return 7'b1000000;
            4'h1: return 7'b1111001;
            4'h2: return 7'b0100100;
            4'h3: return 7'b0110000;
            4'h4: return 7'b0011001;
            4'h5: return 7'b0010010;
            4'h6: return 7'b0000010;
            4'h7: return 7'b1111000;
            4'h8: return 7'b0000000;
            4'h9: return 7'b0010000;
            4'hA: return 7'b0001000;
            4'hB: return 7'b0000011;
            4'hC: return 7'b1000110;
            4'hD: return 7'b0100001;
            4'hE: return 7'b0000110;
            4'hF: return 7'b0001110;
            default: return 7'b1111111;
        endcase
    endfunction
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        for (int i = 0; i < 16; i++) begin
            I = i[3:0];
            #1;
            if (out !== exp_pat(I)) begin
                bad++;
                $display("FAIL I=%0h", I);
            end
        end
        if (bad == 0) $display("ALL TESTS PASS");
        else          $display("FAIL: %0d errors", bad);
    end
endmodule
