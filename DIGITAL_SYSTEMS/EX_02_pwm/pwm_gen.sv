`timescale 1ns/1ps
// PWM Generator: adjustable duty cycle
module pwm_gen #(
    parameter int PERIOD = 100
) (
    input  logic clk, rst,
    input  logic [7:0] duty,  // 0-255 (0-100%)
    output logic pwm
);
    logic [7:0] counter;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) counter <= 8'd0;
        else if (counter == PERIOD - 1) counter <= 8'd0;
        else counter <= counter + 8'd1;
    end
    // Compare counter with duty (scaled)
    logic [7:0] threshold;
    assign threshold = (duty * PERIOD) / 256;
    assign pwm = (counter < threshold) ? 1'b1 : 1'b0;
endmodule
