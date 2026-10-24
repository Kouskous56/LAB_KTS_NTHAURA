`timescale 1ns/1ps
module tb;
    logic [3:0] d; logic [1:0] y; logic valid;
    prienc4to2 u (.d(d),.y(y),.valid(valid));
    int bad=0;
    initial begin
        // No input active
        d=4'b0000; #1; if (valid !== 0) begin bad++; $display("FAIL no-input"); end
        // Single inputs
        d=4'b0001; #1; if (y!==2'b00 || valid!==1) begin bad++; $display("FAIL d0"); end
        d=4'b0010; #1; if (y!==2'b01 || valid!==1) begin bad++; $display("FAIL d1"); end
        d=4'b0100; #1; if (y!==2'b10 || valid!==1) begin bad++; $display("FAIL d2"); end
        d=4'b1000; #1; if (y!==2'b11 || valid!==1) begin bad++; $display("FAIL d3"); end
        // Priority: d[1] and d[3] active -> should report d[3]
        d=4'b1010; #1; if (y!==2'b11) begin bad++; $display("FAIL priority: got %b", y); end
        // Priority: d[0] and d[2] active -> should report d[2]
        d=4'b0101; #1; if (y!==2'b10) begin bad++; $display("FAIL priority2: got %b", y); end
        if (bad==0) $display("EX_06 ALL TESTS PASS"); else $display("EX_06 FAIL: %0d", bad);
    end
endmodule
