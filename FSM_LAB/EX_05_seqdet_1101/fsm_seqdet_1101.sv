`timescale 1ns/1ps
// Sequence detector: detects "1101" (Moore, overlapping)
module fsm_seqdet_1101 (
    input  logic clk, rst, x,
    output logic z
);
    typedef enum logic [2:0] {S0, S1, S2, S3, S4} state_t;
    state_t state, next_state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) state <= S0;
        else     state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            S0: if (x) next_state = S1; else next_state = S0;
            S1: if (x) next_state = S2; else next_state = S0;
            S2: if (x) next_state = S2; else next_state = S3;
            S3: if (x) next_state = S4; else next_state = S0;
            S4: if (x) next_state = S2; else next_state = S0;
        endcase
    end

    // Moore output: depends on state only
    always_comb begin
        case (state)
            S4: z = 1'b1;
            default: z = 1'b0;
        endcase
    end
endmodule
