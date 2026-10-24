`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1; logic motion=0, light_sensor=0, temp_high=0;
    logic [1:0] mode=2'b00;
    logic light, fan, alarm, door_lock;
    smart_home u (.clk(clk),.rst(rst),.motion(motion),.light_sensor(light_sensor),
                  .temp_high(temp_high),.mode(mode),.light(light),.fan(fan),
                  .alarm(alarm),.door_lock(door_lock));
    int bad=0;
    initial begin
        rst=1;
        for (int i=0;i<2;i++) begin clk=0; #5; clk=1; #5; clk=0; #5; end
        rst=0; #5;
        // Auto mode: motion=1, dark -> light on
        mode=2'b00; motion=1; light_sensor=0; #5;
        if (light !== 1) begin bad++; $display("FAIL auto light"); end
        // Night mode: motion=1 -> alarm
        mode=2'b10; motion=1; #5;
        if (alarm !== 1 || door_lock !== 1) begin bad++; $display("FAIL night"); end
        // Away mode: motion=1 -> alarm + lock
        mode=2'b11; motion=1; #5;
        if (alarm !== 1 || door_lock !== 1 || light !== 0) begin bad++; $display("FAIL away"); end
        if (bad==0) $display("EX_07 ALL TESTS PASS"); else $display("EX_07 FAIL: %0d", bad);
        $finish;
    end
endmodule
