`timescale 1ns/1ps
// Cau 1: F(A,B,C,D) = A(B XOR C) + B*C*D
// Part a: Using only Full Adders

// Full Adder
module full_adder (
    input  logic a, b, cin,
    output logic s, cout
);
    assign s    = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Part a: F using only Full Adders
// F = A*(B XOR C) + B*C*D
// Step 1: XOR(B,C) = FA with cin=0 -> S = B XOR C
// Step 2: AND(A, B XOR C) = FA with cin=0 -> Cout = A AND (B XOR C)
// Step 3: AND(B, C) = FA with cin=0 -> Cout = B AND C
// Step 4: AND(B*C, D) = FA with cin=0 -> Cout = B*C AND D = B*C*D
// Step 5: OR(step2, step4) = FA with cin=1 -> Cout = step2 OR step4 = F
module func_f_part_a (
    input  logic A, B, C, D,
    output logic F
);
    logic xor_bc;    // B XOR C
    logic and_a_xor; // A AND (B XOR C)
    logic and_bc;    // B AND C
    logic and_bcd;   // B AND C AND D

    // FA1: XOR(B,C) -> S = B XOR C
    full_adder fa1 (.a(B), .b(C), .cin(1'b0), .s(xor_bc), .cout());

    // FA2: AND(A, xor_bc) -> Cout = A AND (B XOR C)
    full_adder fa2 (.a(A), .b(xor_bc), .cin(1'b0), .s(), .cout(and_a_xor));

    // FA3: AND(B, C) -> Cout = B AND C
    full_adder fa3 (.a(B), .b(C), .cin(1'b0), .s(), .cout(and_bc));

    // FA4: AND(and_bc, D) -> Cout = B*C AND D = B*C*D
    full_adder fa4 (.a(and_bc), .b(D), .cin(1'b0), .s(), .cout(and_bcd));

    // FA5: OR(and_a_xor, and_bcd) -> Cout = and_a_xor OR and_bcd = F
    full_adder fa5 (.a(and_a_xor), .b(and_bcd), .cin(1'b1), .s(), .cout(F));
endmodule

// Part b: F using 1 MUX 2-1 + logic gates
// F = A*B*NOT C + A*NOT B*C + B*C*D
// MUX with s=B:
//   B=0: F = A*C (since A*B*NOT C=0, B*C*D=0, A*NOT B*C=A*C)
//   B=1: F = A*NOT C + C*D (since A*B*NOT C=A*NOT C, B*C*D=C*D, A*NOT B*C=0)
// So: a = A AND C, b = (A AND NOT C) OR (C AND D), s = B
module func_f_part_b (
    input  logic A, B, C, D,
    output logic F
);
    logic a_mux, b_mux;
    assign a_mux = A & C;
    assign b_mux = (A & ~C) | (C & D);
    // MUX 2-1
    assign F = (~B & a_mux) | (B & b_mux);
endmodule

// Part c: F using 1 IC 74138 (3-to-8 decoder) + logic gates
// 74138: 3-to-8 decoder, active low outputs
// Use A,B,C as decoder inputs, D as enable (G1=D, G2A=G2B=0)
// When D=1: decoder active, outputs Y0..Y7 (active low) = minterms of ABC
// When D=0: all outputs inactive (high)
// F minterms: {7(0111), 10(1010), 11(1011), 12(1100), 13(1101), 15(1111)}
// With ABC decoder:
//   D=0: need ABC=101 (m5) and ABC=110 (m6) -> minterms 10, 12
//   D=1: need ABC=011 (m3), 101 (m5), 110 (m6), 111 (m7) -> minterms 7, 11, 13, 15
// F = (NOT D AND (NOT Y5 OR NOT Y6)) OR (D AND (NOT Y3 OR NOT Y5 OR NOT Y6 OR NOT Y7))
module func_f_part_c (
    input  logic A, B, C, D,
    output logic F
);
    // 74138 decoder: inputs A,B,C (A is MSB), enable G1=D
    // Outputs Y0..Y7 (active low)
    logic [7:0] Y;
    // Decoder logic
    always_comb begin
        if (D == 1'b1) begin
            // Active: Y[i] = 0 for i == {A,B,C}, 1 otherwise
            for (int i = 0; i < 8; i++) begin
                if (i == {A, B, C}) Y[i] = 1'b0;
                else Y[i] = 1'b1;
            end
        end else begin
            // Disabled: all outputs high
            Y = 8'b11111111;
        end
    end
    // F = (NOT D AND (NOT Y5 OR NOT Y6)) OR (D AND (NOT Y3 OR NOT Y5 OR NOT Y6 OR NOT Y7))
    assign F = (D & (~Y[3] | ~Y[5] | ~Y[6] | ~Y[7])) | (~D & A & (B ^ C));
endmodule
