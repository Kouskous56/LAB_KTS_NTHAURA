`timescale 1ns/1ps
module tb_7447;
    logic [3:0] bcd; logic rbi_n; logic [6:0] seg_n; logic rbo_n;
    ic_7447 u(.bcd(bcd),.rbi_n(rbi_n),.seg_n(seg_n),.rbo_n(rbo_n));
    int bad=0;
    initial begin
        rbi_n = 1'b1;
        for (int i=0;i<10;i++) begin bcd=i[3:0]; #1;
            // 0 should show 1000000
            if (i==0 && seg_n !== 7'b1000000) begin bad++; $display("FAIL 0: %b", seg_n); end
            if (i==1 && seg_n !== 7'b1111001) begin bad++; $display("FAIL 1"); end
            if (i==8 && seg_n !== 7'b0000000) begin bad++; $display("FAIL 8"); end
        end
        // blanking: bcd=0, rbi_n=0 -> all off
        bcd=4'd0; rbi_n=0; #1;
        if (seg_n !== 7'b1111111) begin bad++; $display("FAIL blank"); end
        if (bad==0) $display("7447 ALL TESTS PASS"); else $display("7447 FAIL: %0d", bad);
    end
endmodule
