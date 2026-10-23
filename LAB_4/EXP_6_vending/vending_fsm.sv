`timescale 1ns/1ps
module vending_fsm (
    input  logic clk,
    input  logic rst,
    input  logic red,
    input  logic blue,
    output logic food,
    output logic water
);
    typedef enum logic [2:0] {S0, R1, R2, B1, F, W} state_t;
    state_t state, next_state;

    always @(posedge clk) begin
        if (rst) state <= S0;
        else     state <= next_state;
    end

    always @(*) begin
        case (state)
            S0: begin
                if (red && !blue) next_state = R1;
                else if (blue && !red) next_state = B1;
                else next_state = S0;
            end
            R1: begin
                if (red && !blue) next_state = R2;
                else if (blue && !red) next_state = S0;
                else next_state = R1;
            end
            R2: begin
                if (red && !blue) next_state = F;
                else if (blue && !red) next_state = S0;
                else next_state = R2;
            end
            B1: begin
                if (red && !blue) next_state = S0;
                else if (blue && !red) next_state = W;
                else next_state = B1;
            end
            F: begin
                if (red || blue) next_state = S0;
                else next_state = F;
            end
            W: begin
                if (red || blue) next_state = S0;
                else next_state = W;
            end
            default: next_state = S0;
        endcase
    end

    assign food  = (state == F);
    assign water = (state == W);
endmodule
