`timescale 1ns/1ps
// EXP_3_2 (cách 2): 4-bit adder/subtractor dựng từ 4 khối Full Adder
// theo sơ đồ Figure 3.1 (4-bit parallel adder, ripple-carry).
//   Sel=0 -> S = A + B
//   Sel=1 -> S = A - B  (bù hai: A + ~B + 1)
// Dây carry: Cin -> Ci(FA1) -> Co(FA1) -> Ci(FA2) -> ... -> Cout
module addsub_4bit_fa (
    input  logic       Sel,
    input  logic [3:0] A, B,
    output logic [3:0] S,
    output logic       Cout
);
    wire c0, c1, c2, c3;
    // B đảo khi trừ: ~B = B xor 1111 (tương đương 4 cổng XOR 74LS86)
    wire [3:0] Bx = B ^ {4{Sel}};

    full_adder fa0 (.A(A[0]), .B(Bx[0]), .Ci(Sel),      .S(S[0]), .Co(c0));
    full_adder fa1 (.A(A[1]), .B(Bx[1]), .Ci(c0),       .S(S[1]), .Co(c1));
    full_adder fa2 (.A(A[2]), .B(Bx[2]), .Ci(c1),       .S(S[2]), .Co(c2));
    full_adder fa3 (.A(A[3]), .B(Bx[3]), .Ci(c2),       .S(S[3]), .Co(Cout));
endmodule
