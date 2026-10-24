`timescale 1ns/1ps
// Traffic light FSM - Manual mode
// States: NS_GO, NS_WARN, EW_GO, EW_WARN
// Yellow phase: 3 seconds (countdown 3,2,1 then transition)
module traffic_fsm_manual (
    input  logic clk,
    input  logic rst,
    input  logic sw0,           // 0=NS go, 1=EW go
    input  logic tick_1s,       // 1 Hz tick
    output logic ns_g, ns_y, ns_r,
    output logic ew_g, ew_y, ew_r,
    output logic [3:0] timer    // countdown display
);
    typedef enum logic [1:0] {NS_GO, NS_WARN, EW_GO, EW_WARN} state_t;
    state_t state;
    logic [3:0] timer_reg;
    logic target_dir;  // 0=NS, 1=EW (latched when entering yellow)

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= NS_GO;
            timer_reg <= 4'd9;  // stable display
            target_dir <= 1'b0;
        end else if (tick_1s) begin
            case (state)
                NS_GO: begin
                    if (sw0 == 1'b1) begin
                        state <= NS_WARN;
                        timer_reg <= 4'd3;
                        target_dir <= 1'b1;
                    end
                end
                NS_WARN: begin
                    if (timer_reg <= 4'd1) begin
                        state <= EW_GO;
                        timer_reg <= 4'd9;
                    end else begin
                        timer_reg <= timer_reg - 4'd1;
                    end
                end
                EW_GO: begin
                    if (sw0 == 1'b0) begin
                        state <= EW_WARN;
                        timer_reg <= 4'd3;
                        target_dir <= 1'b0;
                    end
                end
                EW_WARN: begin
                    if (timer_reg <= 4'd1) begin
                        state <= NS_GO;
                        timer_reg <= 4'd9;
                    end else begin
                        timer_reg <= timer_reg - 4'd1;
                    end
                end
            endcase
        end
    end

    // Output logic (Moore)
    always_comb begin
        ns_g = 0; ns_y = 0; ns_r = 0;
        ew_g = 0; ew_y = 0; ew_r = 0;
        case (state)
            NS_GO:   begin ns_g = 1; ew_r = 1; end
            NS_WARN: begin ns_y = 1; ew_r = 1; end
            EW_GO:   begin ns_r = 1; ew_g = 1; end
            EW_WARN: begin ns_r = 1; ew_y = 1; end
        endcase
    end

    assign timer = timer_reg;
endmodule
