`timescale 1ns/1ps
// Full Adder: x + y + cin = sum + cout
module full_adder (
    input  logic x, y, cin,
    output logic sum, cout
);
    assign sum  = x ^ y ^ cin;
    assign cout = (x & y) | (x & cin) | (y & cin);
endmodule
