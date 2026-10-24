`timescale 1ns/1ps
// FSM with async reset and sync enable
module fsm_reset (
    input  logic clk, rst_async, en,
    input  logic x,
    output logic z
);
    typedef enum logic {IDLE, ACTIVE} state_t;
    state_t state;

    always_ff @(posedge clk or posedge rst_async) begin
        if (rst_async) state <= IDLE;
        else if (en) begin
            case (state)
                IDLE:   if (x) state <= ACTIVE;
                ACTIVE: if (!x) state <= IDLE;
            endcase
        end
    end

    always_comb begin
        case (state)
            IDLE:   z = 1'b0;
            ACTIVE: z = 1'b1;
        endcase
    end
endmodule
