`timescale 1ns/1ps
module clock_divider_core #(parameter int DIVISOR = 50_000_000) (
    input  logic clk_in, rst_in,
    output logic out_signal
);
    localparam int CNT_W = $clog2(DIVISOR);
    logic [CNT_W-1:0] counter;
    always_ff @(posedge clk_in or posedge rst_in) begin
        if (rst_in) begin counter <= '0; out_signal <= 1'b0; end
        else if (counter == DIVISOR - 1) begin counter <= '0; out_signal <= ~out_signal; end
        else counter <= counter + 1'b1;
    end
endmodule
