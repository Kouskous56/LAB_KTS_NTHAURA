`timescale 1ns/1ps
// FSM: detect sequence 101 (Mealy output)
module fsm_seqdet (
    input  logic clk, rst, x,
    output logic z
);
    typedef enum logic [1:0] {S0, S1, S2} state_t;
    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (rst) state <= S0;
        else     state <= next_state;
    end

    always_comb begin
        next_state = state;
        z = 1'b0;
        case (state)
            S0: begin if (x) next_state = S1; end
            S1: begin if (!x) next_state = S2; else next_state = S1; end
            S2: begin if (x) begin next_state = S1; z = 1'b1; end else next_state = S0; end
        endcase
    end
endmodule
