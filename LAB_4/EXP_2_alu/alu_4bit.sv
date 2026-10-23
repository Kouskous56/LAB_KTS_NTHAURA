`timescale 1ns/1ps
// LAB 4 - Experiment 2: 4-bit ALU
// Sel=00: A+B ; 01: A-B ; 10: A AND B ; 11: A OR B
module alu_4bit (
    input  logic [3:0] A,
    input  logic [3:0] B,
    input  logic [1:0] Sel,
    output logic [3:0] S,
    output logic       Co
);
    always @(*) begin
        case (Sel)
            2'b00: begin S = A + B; Co = ({1'b0,A} + B) >= 16; end
            2'b01: begin S = A - B; Co = (A >= B); end
            2'b10: begin S = A & B; Co = 1'b0; end
            2'b11: begin S = A | B; Co = 1'b0; end
            default: begin S = 4'b0; Co = 1'b0; end
        endcase
    end
endmodule
