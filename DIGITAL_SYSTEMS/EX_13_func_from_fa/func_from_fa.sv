`timescale 1ns/1ps
// Design f(w,x,y,z) = w + xyz (OR) using only Full Adders
// Principle:
//   1. FA with cin=0: Cout = a AND b  (AND gate)
//   2. FA with cin=1: Cout = a OR b   (OR gate, since Cout = ab + a + b = a + b)
// Steps:
//   FA1: a=x, b=y, cin=0  => Cout1 = x AND y
//   FA2: a=Cout1, b=z, cin=0 => Cout2 = (x AND y) AND z = x AND y AND z
//   FA3: a=w, b=Cout2, cin=1 => Cout3 = w OR Cout2 = w OR (x AND y AND z) = f
module func_from_fa (
    input  logic w, x, y, z,
    output logic f
);
    logic c1, c2;  // intermediate carries

    // FA1: AND(x, y) -> c1
    full_adder fa1 (.x(x), .y(y), .cin(1'b0), .s(), .cout(c1));

    // FA2: AND(c1, z) -> c2  (c2 = x AND y AND z)
    full_adder fa2 (.x(c1), .y(z), .cin(1'b0), .s(), .cout(c2));

    // FA3: OR(w, c2) -> f  (cin=1 => Cout = w OR c2)
    full_adder fa3 (.x(w), .y(c2), .cin(1'b1), .s(), .cout(f));
endmodule
