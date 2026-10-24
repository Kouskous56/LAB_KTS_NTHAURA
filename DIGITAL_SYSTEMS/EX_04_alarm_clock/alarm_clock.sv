`timescale 1ns/1ps
// Alarm Clock: set time, alarm, snooze
module alarm_clock (
    input  logic clk, rst,
    input  logic tick_1s,
    input  logic [5:0] set_hour, set_min,
    input  logic alarm_set, alarm_clear,
    output logic alarm_ring
);
    logic [5:0] cur_hour = 6'd0, cur_min = 6'd0, cur_sec = 6'd0;
    logic [5:0] alarm_hour = 6'd7, alarm_min = 6'd0;
    logic alarm_enabled = 1'b0;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            cur_hour <= 6'd0; cur_min <= 6'd0; cur_sec <= 6'd0;
            alarm_enabled <= 1'b0; alarm_ring <= 1'b0;
        end else if (tick_1s) begin
            // Update current time
            if (cur_sec == 6'd59) begin
                cur_sec <= 6'd0;
                if (cur_min == 6'd59) begin
                    cur_min <= 6'd0;
                    if (cur_hour == 6'd23) cur_hour <= 6'd0;
                    else cur_hour <= cur_hour + 6'd1;
                end else cur_min <= cur_min + 6'd1;
            end else cur_sec <= cur_sec + 6'd1;

            // Set alarm time
            if (alarm_set) begin alarm_hour <= set_hour; alarm_min <= set_min; alarm_enabled <= 1'b1; end
            if (alarm_clear) begin alarm_enabled <= 1'b0; alarm_ring <= 1'b0; end

            // Check alarm
            if (alarm_enabled && cur_hour == alarm_hour && cur_min == alarm_min && cur_sec == 6'd0)
                alarm_ring <= 1'b1;
        end
    end
endmodule
