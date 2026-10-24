`timescale 1ns/1ps
// Nexys A7: SW[2]=x, SW[1]=y, SW[0]=z ; LED[0]=f
// Implement via 74LS138: A0=x,A1=y,A2=z, E0=1, E1bar=E2bar=0
// f = NAND(Q2bar,Q3bar,Q5bar,Q7bar)
module top_module (
    input  logic [2:0]  SW,
    output logic [15:0] LED
);
    logic x,y,z;
    assign x = SW[2]; assign y = SW[1]; assign z = SW[0];
    logic [2:0] a = {z, y, x};  // A2=z, A1=y, A0=x
    logic [7:0] qbar;
    ic_74138 dec (.a(a), .g1(1'b1), .g2a_n(1'b0), .g2b_n(1'b0), .y_n(qbar));
    // f = NAND of Q2bar,Q3bar,Q5bar,Q7bar
    logic f = ~(qbar[2] & qbar[3] & qbar[5] & qbar[7]);
    assign LED[0]    = f;
    assign LED[15:1] = 15'b0;
endmodule
