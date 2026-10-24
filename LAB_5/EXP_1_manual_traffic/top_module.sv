`timescale 1ns/1ps
// Nexys A7: CLK100MHZ, BTNC reset, SW[0]=direction, SW[1]=mode(unused)
// JA1=NS_G, JA2=NS_Y, JA3=NS_R, JA4=EW_G, JA7=EW_Y, JA8=EW_R
// 7-seg: CA..CG, AN[0], AN[1]
module top_module (
    input  logic        CLK100MHZ,
    input  logic        BTNC,
    input  logic [1:0]  SW,
    output logic        JA1, JA2, JA3, JA4, JA7, JA8,
    output logic        CA, CB, CC, CD, CE, CF, CG,
    output logic [7:0]  AN
);
    logic tick_1s;
    logic ns_g, ns_y, ns_r, ew_g, ew_y, ew_r;
    logic [3:0] timer;
    logic [7:0] an_int;
    logic [6:0] seg_int;

    clock_divider_core u_div (.clk_in(CLK100MHZ), .rst_in(BTNC), .out_signal(tick_1s));
    traffic_fsm_manual u_fsm (.clk(CLK100MHZ), .rst(BTNC), .sw0(SW[0]), .tick_1s(tick_1s),
                             .ns_g(ns_g), .ns_y(ns_y), .ns_r(ns_r),
                             .ew_g(ew_g), .ew_y(ew_y), .ew_r(ew_r), .timer(timer));

    seg7_scan u_seg (.clk(CLK100MHZ), .digit0(timer), .digit1(4'd0),
                    .an(an_int), .seg(seg_int));

    assign JA1 = ns_g; assign JA2 = ns_y; assign JA3 = ns_r;
    assign JA4 = ew_g; assign JA7 = ew_y; assign JA8 = ew_r;
    assign {CG, CF, CE, CD, CC, CB, CA} = seg_int;
    assign AN = an_int;
endmodule
