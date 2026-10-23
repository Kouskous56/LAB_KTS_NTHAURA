`timescale 1ns/1ps
// Nexys A7: CLK100MHZ, BTNC reset, SW[0]=RED, SW[1]=BLUE, LED[0]=FOOD, LED[1]=WATER
module top_module (
    input  logic        CLK100MHZ,
    input  logic        BTNC,
    input  logic [1:0]  SW,
    output logic [15:0] LED
);
    logic food, water;
    vending_fsm u (.clk(CLK100MHZ), .rst(BTNC), .red(SW[0]), .blue(SW[1]), .food(food), .water(water));
    assign LED[0]    = food;
    assign LED[1]    = water;
    assign LED[15:2] = 14'b0;
endmodule
