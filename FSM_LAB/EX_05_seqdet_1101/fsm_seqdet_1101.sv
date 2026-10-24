`timescale 1ns/1ps
// Sequence detector: detects "1101" (Moore, overlapping)
module fsm_seqdet_1101 (
    input  logic clk, rst, x,
    output logic z
);
    typedef enum logic [2:0] {S0, S1, S2, S3, S4} state_t;
    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (rst) state <= S0;
        else     state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S2 : S0;
            S2: next_state = x ? S2 : S3;
            S3: next_state = x ? S4 : S0;
            S4: next_state = x ? S1 : S0;
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
