`timescale 1ns/1ps
// Mealy FSM: 2 states (IDLE, ACTIVE), output depends on state AND input
module mealy_basic (
    input  logic clk, rst,
    input  logic x,
    output logic z
);
    typedef enum logic {IDLE, ACTIVE} state_t;
    state_t state, next_state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else     state <= next_state;
    end

    always_comb begin
        next_state = state;
        z = 1'b0;
        case (state)
            IDLE:   begin if (x) next_state = ACTIVE; z = x; end
            ACTIVE: begin if (!x) next_state = IDLE; z = x; end
        endcase
    end
endmodule
