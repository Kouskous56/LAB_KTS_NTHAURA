`timescale 1ns/1ps
// 74181 - 4-bit arithmetic logic unit (simplified: arithmetic + logic on A,B with select S[3:0] and mode M)
// M=1: logic operations; M=0: arithmetic. Carry-in Cn. Outputs F[3:0], carry-out Cn+4, A=B (active low).
module ic_74181 (
    input  logic [3:0] a, b,
    input  logic [3:0] s,
    input  logic       m,       // mode: 1=logic, 0=arithmetic
    input  logic       c_n,     // carry in (active low)
    output logic [3:0] f,
    output logic       c_n4,    // carry out (active low)
    output logic       aeb      // A equals B (active low)
);
    // Simplified model: implement a subset of 74181 functions.
    // Logic (M=1): F = (A op B) per S
    // Arithmetic (M=0): F = (A + (S?...)) ... simplified to A+B when S=1001? 
    // For teaching, implement the 16 logic functions and basic arithmetic add/sub.
    always @(*) begin
        if (m) begin
            // logic functions
            case (s)
                4'h0: f = ~a;           4'h1: f = ~(a | b);      4'h2: f = (~a) & b;     4'h3: f = 4'b0;
                4'h4: f = ~(a & b);     4'h5: f = ~b;            4'h6: f = a ^ b;         4'h7: f = a & (~b);
                4'h8: f = (~a) | b;     4'h9: f = ~(a ^ b);     4'hA: f = b;             4'hB: f = a & b;
                4'hC: f = 4'hF;         4'hD: f = a | (~b);      4'hE: f = a | b;         4'hF: f = a;
                default: f = 4'b0;
            endcase
            c_n4 = 1'b1; // no carry in logic mode
        end else begin
            // arithmetic: F = A + (b op) + carry; simplified: treat as A + b + c_n (c_n active low -> +1 if c_n=0)
            logic [4:0] r;
            r = {1'b0, a} + {1'b0, b} + (c_n ? 0 : 1);
            f = r[3:0];
            c_n4 = ~r[4]; // active low carry out
        end
        aeb = (f == 4'b0) ? 1'b0 : 1'b1; // active low: 0 if A==B (simplified: 0 if result 0)
    end
endmodule
