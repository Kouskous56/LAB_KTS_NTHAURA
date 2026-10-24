`timescale 1ns/1ps
// Traffic light FSM: Green -> Yellow -> Red -> Green
module traffic_light (
    input  logic clk, rst,
    input  logic tick_1s,
    output logic green, yellow, red
);
    typedef enum logic [1:0] {GREEN, YELLOW, RED} state_t;
    state_t state;
    logic [1:0] timer;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin state <= GREEN; timer <= 2'd2; end
        else if (tick_1s) begin
            case (state)
                GREEN:  begin if (timer == 2'd0) begin state <= YELLOW; timer <= 2'd1; end else timer <= timer - 2'd1; end
                YELLOW: begin if (timer == 2'd0) begin state <= RED; timer <= 2'd2; end else timer <= timer - 2'd1; end
                RED:    begin if (timer == 2'd0) begin state <= GREEN; timer <= 2'd2; end else timer <= timer - 2'd1; end
            endcase
        end
    end

    always_comb begin
        green = 0; yellow = 0; red = 0;
        case (state)
            GREEN:  green = 1;
            YELLOW: yellow = 1;
            RED:    red = 1;
        endcase
    end
endmodule
