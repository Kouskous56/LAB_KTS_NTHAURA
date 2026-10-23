`timescale 1ns/1ps
// Nexys A7: CLK100MHZ, BTNC reset, 7-seg CA..CG, AN (rightmost digit)
module top_module (
    input  logic        CLK100MHZ,
    input  logic        BTNC,
    output logic        CA, CB, CC, CD, CE, CF, CG,
    output logic [7:0]  AN,
    output logic [15:0] LED
);
    logic tick;
    logic [2:0] cnt;
    logic [6:0] seg;
    clock_divider_core u_div (.clk_in(CLK100MHZ), .rst_in(BTNC), .out_signal(tick));
    down_counter_3bit u_cnt (.clk(tick), .rst(BTNC), .count(cnt));
    bcd7seg u_dec (.I({1'b0, cnt}), .out(seg));
    assign {CG, CF, CE, CD, CC, CB, CA} = seg;
    assign AN = 8'b11111110;
    assign LED = 16'b0;
endmodule
