`timescale 1ns/1ps
module tb;
    logic [3:0] a=4'd0, b=4'd0; logic [1:0] op=2'd0;
    logic [7:0] result; logic overflow;
    calc u (.a(a),.b(b),.op(op),.result(result),.overflow(overflow));
    int bad=0;
    initial begin
        // Add: 5+3=8
        a=4'd5; b=4'd3; op=2'd0; #1; if (result !== 8'd8) begin bad++; $display("FAIL add"); end
        // Sub: 7-2=5
        a=4'd7; b=4'd2; op=2'd1; #1; if (result !== 8'd5) begin bad++; $display("FAIL sub"); end
        // Mul: 3*4=12
        a=4'd3; b=4'd4; op=2'd2; #1; if (result !== 8'd12) begin bad++; $display("FAIL mul"); end
        // Div: 8/2=4
        a=4'd8; b=4'd2; op=2'd3; #1; if (result !== 8'd4) begin bad++; $display("FAIL div"); end
        // Div by zero
        a=4'd8; b=4'd0; op=2'd3; #1; if (overflow !== 1) begin bad++; $display("FAIL div0"); end
        if (bad==0) $display("EX_06 ALL TESTS PASS"); else $display("EX_06 FAIL: %0d", bad);
        $finish;
    end
endmodule
