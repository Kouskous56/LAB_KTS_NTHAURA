`timescale 1ns/1ps
module top_module (
    input  logic [2:0] SW,
    output logic [15:0] LED
);
    logic f;
    f_bool u_f (
        .a (SW[0]),
        .b (SW[1]),
        .c (SW[2]),
        .f (f)
    );
    assign LED[0]     = f;
    assign LED[2:1]   = SW[2:1];
    assign LED[14:3]  = 12'b0;
    assign LED[15]    = f;
endmodule
