`timescale 1ns/1ps
module tb_74151;
    logic [7:0] d; logic [2:0] s; logic g_n, y, w;
    ic_74151 u (.d(d),.s(s),.g_n(g_n),.y(y),.w(w));
    int bad=0;
    initial begin
        // enabled: y = d[s]
        g_n = 0;
        for (int i=0;i<8;i++) begin
            d = 8'b10101010; s = i[2:0]; #1;
            if (y !== d[s] || w !== ~d[s]) begin bad++; if(bad<=5)$display("FAIL en s=%0d", s); end
        end
        // disabled: y=0, w=1
        g_n = 1; s = 3'd0; d = 8'hFF; #1;
        if (y !== 0 || w !== 1) begin bad++; $display("FAIL dis"); end
        if (bad==0) $display("74151 ALL TESTS PASS"); else $display("74151 FAIL: %0d", bad);
    end
endmodule
