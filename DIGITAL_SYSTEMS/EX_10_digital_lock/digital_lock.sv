`timescale 1ns/1ps
// Digital Lock: password "101" (3-bit sequence)
module digital_lock (
    input  logic clk, rst,
    input  logic x,          // input bit
    input  logic enter,      // enter button
    output logic unlock,      // unlock signal
    output logic error       // wrong password
);
    typedef enum logic [2:0] {IDLE, S1, S2, S3, UNLOCK, ERROR} state_t;
    state_t state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else begin
            case (state)
                IDLE:    if (enter) begin if (x) state <= S1; else state <= ERROR; end
                S1:      if (enter) begin if (!x) state <= S2; else state <= ERROR; end
                S2:      if (enter) begin if (x) state <= UNLOCK; else state <= ERROR; end
                UNLOCK:  state <= IDLE;
                ERROR:   if (enter) state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    assign unlock = (state == UNLOCK);
    assign error = (state == ERROR);
endmodule
