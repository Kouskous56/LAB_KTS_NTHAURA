`timescale 1ns/1ps
// Simple Calculator: add, sub, mul, div
module calc (
    input  logic [3:0] a, b,
    input  logic [1:0] op,   // 00=add, 01=sub, 10=mul, 11=div
    output logic [7:0] result,
    output logic       overflow
);
    always_comb begin
        case (op)
            2'b00: begin result = a + b; overflow = (a + b > 8'd15); end
            2'b01: begin result = a - b; overflow = (a < b); end
            2'b10: begin result = a * b; overflow = (a * b > 8'd15); end
            2'b11: begin if (b != 0) result = a / b; else result = 8'd0; overflow = (b == 0); end
            default: begin result = 8'd0; overflow = 1'b0; end
        endcase
    end
endmodule
