`timescale 1ns/1ps
// Nexys A7: SW[3:0]=I ; CA..CG=segments ({g..a}) ; AN[0]=0 (rightmost digit)
module top_module (
    input  logic [3:0]  SW,
    output logic [15:0] LED,
    output logic        CA, CB, CC, CD, CE, CF, CG,
    output logic [7:0]  AN
);
    logic [6:0] seg;
    bcd7seg u (.I(SW[3:0]), .out(seg));
    assign {CG, CF, CE, CD, CC, CB, CA} = seg;
    assign AN = 8'b11111110;
    assign LED = 16'b0;
endmodule
