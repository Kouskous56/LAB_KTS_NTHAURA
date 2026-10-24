`timescale 1ns/1ps
// Full Adder (same as before)
module full_adder (
    input  logic x, y, cin,
    output logic s, cout
);
    assign s    = x ^ y ^ cin;
    assign cout = (x & y) | (x & cin) | (y & cin);
endmodule
