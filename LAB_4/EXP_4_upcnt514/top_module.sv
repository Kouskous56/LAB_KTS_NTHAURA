`timescale 1ns/1ps
// Nexys A7: CLK100MHZ (via divider -> 1s tick), SW[0]=rst (active high), LED[3:0]=count
module top_module (
    input  logic        CLK100MHZ,
    input  logic [0:0]  SW,
    output logic [15:0] LED
);
    logic tick;
    logic [3:0] cnt;
    clock_divider_core u_div (.clk_in(CLK100MHZ), .rst_in(SW[0]), .out_signal(tick));
    up_counter_5to14 u_cnt (.clk(tick), .rst(SW[0]), .count(cnt));
    assign LED[3:0]  = cnt;
    assign LED[15:4] = 12'b0;
endmodule
