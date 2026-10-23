`timescale 1ns/1ps
module tb_7475;
    logic [3:0] d, q, q_n; logic en;
    ic_7475 u (.d(d),.en(en),.q(q),.q_n(q_n));
    int bad=0;
    initial begin
        en=1; d=4'b1010; #5; if (q!==4'b1010) begin bad++; $display("FAIL transparent"); end
        d=4'b0101; #5; if (q!==4'b0101) begin bad++; $display("FAIL transparent2"); end
        en=0; d=4'b1111; #5; if (q!==4'b0101) begin bad++; $display("FAIL hold"); end
        if (q_n !== ~q) begin bad++; $display("FAIL q_n"); end
        if (bad==0) $display("7475 ALL TESTS PASS"); else $display("7475 FAIL: %0d", bad);
    end
endmodule
