`timescale 1ns/1ps
// Smart Home Controller: light, fan, security
module smart_home (
    input  logic clk, rst,
    input  logic motion, light_sensor, temp_high,
    input  logic [1:0] mode,  // 00=auto, 01=manual, 10=night, 11=away
    output logic light, fan, alarm, door_lock
);
    always_comb begin
        light = 0; fan = 0; alarm = 0; door_lock = 0;
        case (mode)
            2'b00: begin // Auto
                light = motion & ~light_sensor;
                fan = temp_high;
                alarm = 0;
                door_lock = 0;
            end
            2'b01: begin // Manual (all off by default)
                light = 0; fan = 0; alarm = 0; door_lock = 0;
            end
            2'b10: begin // Night
                light = motion;
                fan = 0;
                alarm = motion;
                door_lock = 1;
            end
            2'b11: begin // Away
                light = 0;
                fan = 0;
                alarm = motion;
                door_lock = 1;
            end
        endcase
    end
endmodule
