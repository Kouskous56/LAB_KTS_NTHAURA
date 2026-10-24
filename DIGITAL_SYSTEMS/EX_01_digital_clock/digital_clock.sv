`timescale 1ns/1ps
// Digital Clock: HH:MM:SS with 12/24 hour mode
module digital_clock (
    input  logic clk, rst,
    input  logic tick_1s,       // 1 Hz tick
    input  logic mode_12h,     // 0=24h, 1=12h
    output logic [5:0] seconds,
    output logic [5:0] minutes,
    output logic [4:0] hours,   // 0-23 (24h) or 1-12 (12h)
    output logic       am_pm    // 0=AM, 1=PM (12h mode)
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            seconds <= 6'd0; minutes <= 6'd0; hours <= 5'd0; am_pm <= 1'b0;
        end else if (tick_1s) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    if (mode_12h) begin
                        if (hours == 5'd12) begin hours <= 5'd1; am_pm <= ~am_pm; end
                        else if (hours == 5'd11) begin hours <= 5'd12; end
                        else hours <= hours + 5'd1;
                    end else begin
                        if (hours == 5'd23) hours <= 5'd0;
                        else hours <= hours + 5'd1;
                    end
                end else begin
                    minutes <= minutes + 6'd1;
                end
            end else begin
                seconds <= seconds + 6'd1;
            end
        end
    end
endmodule
