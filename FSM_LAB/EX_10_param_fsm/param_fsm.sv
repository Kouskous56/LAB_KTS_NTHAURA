`timescale 1ns/1ps
// Parametric N-state FSM (Moore)
module param_fsm #(parameter N = 4) (
    input  logic clk, rst,
    input  logic x,
    output logic [$clog2(N)-1:0] state_out,
    output logic z
);
    logic [$clog2(N)-1:0] state, next_state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) state <= '0;
        else     state <= next_state;
    end

    always_comb begin
        next_state = state;
        // Simple: increment state on x=1, reset on x=0
        if (x) next_state = (state == N-1) ? '0 : state + 1'b1;
        else   next_state = '0;
    end

    // Moore output: z=1 when state is last state
    assign z = (state == N-1);
    assign state_out = state;
endmodule
