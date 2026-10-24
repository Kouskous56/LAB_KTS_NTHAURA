`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1; logic [7:0] duty=8'd128; logic pwm;
    pwm_gen #(10) u (.clk(clk),.rst(rst),.duty(duty),.pwm(pwm));
    int bad=0;
    int high_count;
    initial begin
        rst=1;
        for (int i=0;i<2;i++) begin clk=0; #5; clk=1; #5; clk=0; #5; end
        rst=0; #5;
        // duty=50% (128/256), period=10 -> threshold=5
        // pwm should be high for 5 cycles, low for 5
        high_count = 0;
        for (int i=0;i<10;i++) begin
            clk=0; #5; clk=1; #5; clk=0; #5;
            if (pwm) high_count++;
        end
        if (high_count !== 5) begin bad++; $display("FAIL high_count: %0d (exp 5)", high_count); end
        // duty=0% -> always low
        duty = 8'd0; #5;
        clk=0; #5; clk=1; #5; clk=0; #5;
        if (pwm !== 0) begin bad++; $display("FAIL duty0"); end
        // duty=100% (255) -> always high
        duty = 8'd255; #5;
        clk=0; #5; clk=1; #5; clk=0; #5;
        if (pwm !== 1) begin bad++; $display("FAIL duty255"); end
        if (bad==0) $display("EX_02 ALL TESTS PASS"); else $display("EX_02 FAIL: %0d", bad);
        $finish;
    end
endmodule
