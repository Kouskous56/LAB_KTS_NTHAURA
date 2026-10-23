`timescale 1ns/1ps
module fsm_4state_core (
    input  wire       clk,
    input  wire       rst,
    input  wire       x_in,
    output reg  [1:0] y_out
);
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;
    reg [1:0] current_state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) current_state <= S0;
        else     current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            S0: begin if (x_in) next_state = S1; else next_state = S0; end
            S1: begin if (!x_in) next_state = S2; else next_state = S0; end
            S2: begin if (!x_in) next_state = S3; else next_state = S2; end
            S3: begin if (!x_in) next_state = S0; else next_state = S3; end
            default: next_state = S0;
        endcase
    end

    always @(*) begin
        case (current_state)
            S0: y_out = 2'b00;
            S1: y_out = 2'b10;
            S2: y_out = 2'b11;
            S3: y_out = 2'b01;
            default: y_out = 2'b00;
        endcase
    end
endmodule
