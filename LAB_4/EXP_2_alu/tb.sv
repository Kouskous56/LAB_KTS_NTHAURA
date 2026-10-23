`timescale 1ns/1ps
module tb;
    logic [3:0] A, B;
    logic [1:0] Sel;
    logic [3:0] S;
    logic       Co;
    alu_4bit u (.A(A), .B(B), .Sel(Sel), .S(S), .Co(Co));
    int bad = 0;
    initial begin
        logic [3:0] eS;
        logic       eCo;
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        for (int s = 0; s < 4; s++)
            for (int a = 0; a < 16; a++)
                for (int b = 0; b < 16; b++) begin
                    Sel = s[1:0]; A = a[3:0]; B = b[3:0];
                    #1;
                    case (Sel)
                        2'b00: begin eS = A + B; eCo = ({1'b0,A}+B) >= 16; end
                        2'b01: begin eS = A - B; eCo = (A >= B); end
                        2'b10: begin eS = A & B; eCo = 1'b0; end
                        2'b11: begin eS = A | B; eCo = 1'b0; end
                        default: begin eS = 4'b0; eCo = 1'b0; end
                    endcase
                    if (S !== eS || Co !== eCo) begin
                        bad++;
                        if (bad <= 10)
                            $display("FAIL Sel=%b A=%0d B=%0d : S=%0d Co=%b (exp %0d/%b)", Sel, A, B, S, Co, eS, eCo);
                    end
                end
        if (bad == 0) $display("ALL TESTS PASS");
        else          $display("FAIL: %0d errors", bad);
        $finish;
    end
endmodule
