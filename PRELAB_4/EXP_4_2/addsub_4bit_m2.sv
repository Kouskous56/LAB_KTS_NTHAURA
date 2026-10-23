`timescale 1ns/1ps
// Method 2: dataflow
module addsub_4bit_m2 (
    input  logic [3:0] A, B,
    input  logic       sel,
    output logic [3:0] S,
    output logic       Co
);
    logic [4:0] res;
    assign res = sel ? ({1'b0, A} + {1'b0, ~B} + 5'd1) : ({1'b0, A} + {1'b0, B});
    assign S  = res[3:0];
    assign Co = res[4];
endmodule
