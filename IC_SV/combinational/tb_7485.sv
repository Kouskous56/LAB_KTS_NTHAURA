`timescale 1ns/1ps
module tb_7485;
    logic [3:0] a,b; logic agt,aeq,alt, a_gt_b,a_eq_b,a_lt_b;
    ic_7485 u(.a(a),.b(b),.a_gt_b_in(agt),.a_eq_b_in(aeq),.a_lt_b_in(alt),.a_gt_b(a_gt_b),.a_eq_b(a_eq_b),.a_lt_b(a_lt_b));
    int bad=0;
    initial begin
        agt=0; aeq=1; alt=0;
        // a > b
        a=4'd7; b=4'd3; #1; if (a_gt_b!==1 || a_eq_b!==0 || a_lt_b!==0) begin bad++; $display("FAIL gt"); end
        // a < b
        a=4'd2; b=4'd9; #1; if (a_lt_b!==1) begin bad++; $display("FAIL lt"); end
        // a == b with cascade eq=1
        a=4'd5; b=4'd5; #1; if (a_eq_b!==1) begin bad++; $display("FAIL eq"); end
        // cascade: a==b, cascade says greater
        agt=1; aeq=0; alt=0; a=4'd5; b=4'd5; #1; if (a_gt_b!==1) begin bad++; $display("FAIL cascade gt"); end
        if (bad==0) $display("7485 ALL TESTS PASS"); else $display("7485 FAIL: %0d", bad);
    end
endmodule
