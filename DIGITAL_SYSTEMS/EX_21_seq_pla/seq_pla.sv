`timescale 1ns/1ps
// Cau 7: Sequential system with 1 input X, 2 outputs Z1 (Moore), Z2 (Mealy)
// State diagram: S0, S1, S2, S3
// Z1 (Moore): S0=1, S1=0, S2=1, S3=0
// Transitions (X/Z2):
//   S0: X=0 -> S3 (Z2=1), X=1 -> S1 (Z2=1)
//   S1: X=0 -> S1 (Z2=0), X=1 -> S0 (Z2=1)
//   S2: X=0 -> S3 (Z2=1), X=1 -> S1 (Z2=0)
//   S3: X=0 -> S0 (Z2=1), X=1 -> S1 (Z2=1)
//   (Note: S3 has ambiguity for X=0 in original problem; using S3->S0)
//
// State encoding: QAQB: S0=10, S1=11, S2=00, S3=01
// Design using PLA and T-FF

// T-FF (negative edge, for simulation)
module t_ff (
    input  logic clk, rst,
    input  logic T,
    output logic Q
);
    always_ff @(negedge clk) begin
        if (rst) Q <= 1'b0;
        else     Q <= T ^ Q;
    end
endmodule

module seq_pla (
    input  logic clk, rst,
    input  logic X,
    output logic Z1, Z2,
    output logic [1:0] QAQB  // state encoding
);
    logic QA, QB;
    logic TA, TB;  // T-FF inputs from PLA

    // PLA: T_A = NOT QA * (QB + X) + QA * NOT QB * NOT X
    assign TA = (~QA & (QB | X)) | (QA & ~QB & ~X);

    // T_B = NOT QB + NOT QA * QB * NOT X + QA * QB * X
    assign TB = ~QB | (~QA & QB & ~X) | (QA & QB & X);

    // Z1 (Moore) = NOT QB
    assign Z1 = ~QB;

    // Z2 (Mealy) = NOT QA * NOT X + NOT QA * QB + QA * NOT QB + QA * QB * X
    assign Z2 = (~QA & ~X) | (~QA & QB) | (QA & ~QB) | (QA & QB & X);

    // T-FF instances
    t_ff ff_a (.clk(clk), .rst(rst), .T(TA), .Q(QA));
    t_ff ff_b (.clk(clk), .rst(rst), .T(TB), .Q(QB));

    assign QAQB = {QA, QB};
endmodule
