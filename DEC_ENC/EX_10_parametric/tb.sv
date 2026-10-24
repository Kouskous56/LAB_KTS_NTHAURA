`timescale 1ns/1ps
module tb;
    // Test 2-to-4 decoder
    logic [1:0] a2; logic en2; logic [3:0] y2;
    dec_param #(2) dec2 (.a(a2),.en(en2),.y(y2));
    // Test 3-to-8 decoder
    logic [2:0] a3; logic en3; logic [7:0] y3;
    dec_param #(3) dec3 (.a(a3),.en(en3),.y(y3));
    // Test 4-to-2 encoder
    logic [3:0] d4; logic [1:0] y4; logic v4;
    enc_param #(2) enc2 (.d(d4),.y(y4),.valid(v4));
    // Test 8-to-3 encoder
    logic [7:0] d8; logic [2:0] y8; logic v8;
    enc_param #(3) enc3 (.d(d8),.y(y8),.valid(v8));
    int bad=0;
    initial begin
        en2 = 1; en3 = 1;
        for (int i=0;i<4;i++) begin a2=i[1:0]; #1; if (y2 !== (4'b1<<a2)) begin bad++; $display("FAIL dec2"); end end
        for (int i=0;i<8;i++) begin a3=i[2:0]; #1; if (y3 !== (8'b1<<a3)) begin bad++; $display("FAIL dec3"); end end
        // Test encoder
        d4 = 4'b0000; #1; if (v4 !== 0) begin bad++; $display("FAIL enc2 valid"); end
        d4 = 4'b1010; #1; if (y4 !== 3 || v4 !== 1) begin bad++; $display("FAIL enc2: got %0d", y4); end
        d8 = 8'b00000000; #1; if (v8 !== 0) begin bad++; $display("FAIL enc3 valid"); end
        d8 = 8'b10000000; #1; if (y8 !== 7 || v8 !== 1) begin bad++; $display("FAIL enc3: got %0d", y8); end
        if (bad==0) $display("EX_10 ALL TESTS PASS"); else $display("EX_10 FAIL: %0d", bad);
    end
endmodule
