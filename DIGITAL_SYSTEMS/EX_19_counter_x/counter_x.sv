`timescale 1ns/1ps
// Cau 5: 3-bit synchronous counter Q1Q2Q3 (Q1=MSB), X = control input
// D1 = X XOR Q3
// D2 = Q2 XOR (Q1 AND X)
// D3 = Q1
// All D-FFs share common clock CK.

module counter_x (
    input  logic clk, rst,
    input  logic X,
    output logic [2:0] Q  // Q[0]=Q1(MSB), Q[1]=Q2, Q[2]=Q3(LSB)... 
    // Actually Q1=MSB, Q2, Q3=LSB. Let's use Q[2]=Q1, Q[1]=Q2, Q[0]=Q3
);
    // D-FF inputs
    logic D1, D2, D3;

    // Combinational logic for D inputs
    always_comb begin
        D1 = X ^ Q[0];              // X XOR Q3 (Q[0]=Q3)
        D2 = Q[1] ^ (Q[2] & X);     // Q2 XOR (Q1 AND X)
        D3 = Q[2];                   // Q1
    end

    // D-FFs (positive edge, sync reset)
    always_ff @(posedge clk) begin
        if (rst) begin
            Q <= 3'b000;
        end else begin
            Q[2] <= D1;  // Q1
            Q[1] <= D2;  // Q2
            Q[0] <= D3;  // Q3
        end
    end
endmodule
