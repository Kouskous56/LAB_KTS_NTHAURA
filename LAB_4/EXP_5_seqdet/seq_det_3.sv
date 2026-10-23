`timescale 1ns/1ps
// LAB 4 - Experiment 5: Z=1 when (#ones divisible by 3) AND (#zeros even and >0)
// State = {r[1:0] (ones mod3), p (zero parity: 0=even), t (seen>=2 zeros)}
module seq_det_3 (
    input  logic clk,
    input  logic rst,
    input  logic x,
    output logic z
);
    logic [3:0] state, next_state;
    // state bits: [3:2]=r, [1]=p, [0]=t
    always @(posedge clk) begin
        if (rst) state <= 4'b0000;
        else     state <= next_state;
    end
    always @(*) begin
        logic [1:0] r;
        logic       p;
        logic       t;
        r = state[3:2];
        p = state[1];
        t = state[0];
        if (x == 1'b1) begin
            next_state = { (r == 2'd2) ? 2'd0 : (r + 2'd1), p, t };
        end else begin
            next_state = { r, ~p, t | p };
        end
    end
    assign z = (state[3:2] == 2'd0) && (state[1] == 1'b0) && (state[0] == 1'b1);
endmodule
