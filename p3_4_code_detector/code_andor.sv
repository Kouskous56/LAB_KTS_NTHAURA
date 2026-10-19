`timescale 1ns/1ps
// part a: code detector using AND-OR gates
// valid code iff A=B=C (D,E don't care): Y = ~A~B~C + A·B·C
module code_andor (
    input  logic A, B, C, D, E,
    output logic Y
);
    logic T0, T1;
    // D, E unused: minimized with don't cares
    assign T0 = ~A & ~B & ~C;
    assign T1 =  A &  B &  C;
    assign Y  = T0 | T1;
endmodule
