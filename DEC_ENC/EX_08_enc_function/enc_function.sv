`timescale 1ns/1ps
// Use priority encoder to implement a function
// f(x,y,z) = 1 when any input is 1 (OR of all inputs)
module enc_function (
    input  logic x, y, z,
    output logic f,
    output logic [1:0] encoded
);
    // Priority encoder: x > y > z
    always_comb begin
        if (x == 1'b1) begin encoded = 2'b10; f = 1'b1; end
        else if (y == 1'b1) begin encoded = 2'b01; f = 1'b1; end
        else if (z == 1'b1) begin encoded = 2'b00; f = 1'b1; end
        else begin encoded = 2'b00; f = 1'b0; end
    end
endmodule
