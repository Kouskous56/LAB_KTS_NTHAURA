`timescale 1ns/1ps
module tb;
    logic x,y,z,f; logic [1:0] encoded;
    enc_function u (.x(x),.y(y),.z(z),.f(f),.encoded(encoded));
    int bad=0;
    initial begin
        // Test all combinations
        for (int i=0;i<8;i++) begin
            {x,y,z}=i[2:0]; #1;
            // f should be 1 if any input is 1
            if (f !== (x|y|z)) begin bad++; $display("FAIL f %0d", i); end
            // encoded should be highest priority
            if (x==1 && encoded!==2'b10) begin bad++; $display("FAIL enc x"); end
            else if (x==0 && y==1 && encoded!==2'b01) begin bad++; $display("FAIL enc y"); end
            else if (x==0 && y==0 && z==1 && encoded!==2'b00) begin bad++; $display("FAIL enc z"); end
        end
        if (bad==0) $display("EX_08 ALL TESTS PASS"); else $display("EX_08 FAIL: %0d", bad);
    end
endmodule
