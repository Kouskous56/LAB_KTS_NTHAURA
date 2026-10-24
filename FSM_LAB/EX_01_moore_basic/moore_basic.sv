`timescale 1ns/1ps
// Moore FSM: 2 states (IDLE, ACTIVE), output depends on state only
module moore_basic (
    input  logic clk, rst,
    input  logic x,
    output logic z
);
    typedef enum logic {IDLE, ACTIVE} state_t;
    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (rst) state <= IDLE;
        else     state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE:   if (x) next_state = ACTIVE;
            ACTIVE: if (!x) next_state = IDLE;
        endcase
    end

    // Moore output: depends on state only
    always_comb begin
        case (state)
            IDLE:   z = 1'b0;
            ACTIVE: z = 1'b1;
        endcase
    end
endmodule
