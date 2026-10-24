`timescale 1ns/1ps
// 2-digit 7-segment multiplex driver (active-low, gfedcba)
module seg7_scan (
    input  logic clk,
    input  logic [3:0] digit0,  // right digit
    input  logic [3:0] digit1,  // left digit
    output logic [7:0] an,
    output logic [6:0] seg       // {g,f,e,d,c,b,a}
);
    logic [17:0] refresh_counter;
    logic refresh_tick;
    logic [3:0] current_digit;

    always_ff @(posedge clk) begin
        refresh_counter <= refresh_counter + 1'b1;
    end

    assign refresh_tick = refresh_counter[17];

    always_comb begin
        if (refresh_tick) begin
            an = 8'b1111_1101;  // enable digit 1 (AN1)
            current_digit = digit1;
        end else begin
            an = 8'b1111_1110;  // enable digit 0 (AN0)
            current_digit = digit0;
        end
    end

    always_comb begin
        case (current_digit)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            default: seg = 7'b1111111;  // blank
        endcase
    end
endmodule
