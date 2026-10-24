`timescale 1ns/1ps
// Traffic light FSM - Integrated Manual/Auto mode
// SW1=0: manual mode (SW0 selects direction)
// SW1=1: auto mode (ignores SW0, runs 5/2/5/2 cycle)
module traffic_fsm_integrated (
    input  logic clk,
    input  logic rst,
    input  logic sw0,           // direction (manual only)
    input  logic sw1,           // 0=manual, 1=auto
    input  logic tick_1s,       // 1 Hz tick
    output logic ns_g, ns_y, ns_r,
    output logic ew_g, ew_y, ew_r,
    output logic [3:0] timer    // countdown display
);
    typedef enum logic [2:0] {
        NS_GO, NS_WARN, EW_GO, EW_WARN,      // manual states
        NS_GREEN, NS_YELLOW, EW_GREEN, EW_YELLOW  // auto states
    } state_t;
    state_t state;
    logic [3:0] timer_reg;
    logic mode;  // 0=manual, 1=auto

    always_ff @(posedge clk) begin
        if (rst) begin
            if (sw1 == 1'b1) begin
                state <= NS_GREEN;
                timer_reg <= 4'd5;
            end else begin
                state <= NS_GO;
                timer_reg <= 4'd9;
            end
            mode <= sw1;
        end else if (tick_1s) begin
            mode <= sw1;  // track mode
            if (sw1 != mode) begin
                // mode changed: reset to appropriate start state
                if (sw1) begin
                    state <= NS_GREEN;
                    timer_reg <= 4'd5;
                end else begin
                    state <= NS_GO;
                    timer_reg <= 4'd9;
                end
            end else begin
                case (state)
                    // Manual mode states
                    NS_GO: begin
                        if (sw0 == 1'b1) begin
                            state <= NS_WARN;
                            timer_reg <= 4'd3;
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
                    // Auto mode states
                    NS_GREEN: begin
                        if (timer_reg <= 4'd1) begin
                            state <= NS_YELLOW;
                            timer_reg <= 4'd2;
                        end else begin
                            timer_reg <= timer_reg - 4'd1;
                        end
                    end
                    NS_YELLOW: begin
                        if (timer_reg <= 4'd1) begin
                            state <= EW_GREEN;
                            timer_reg <= 4'd5;
                        end else begin
                            timer_reg <= timer_reg - 4'd1;
                        end
                    end
                    EW_GREEN: begin
                        if (timer_reg <= 4'd1) begin
                            state <= EW_YELLOW;
                            timer_reg <= 4'd2;
                        end else begin
                            timer_reg <= timer_reg - 4'd1;
                        end
                    end
                    EW_YELLOW: begin
                        if (timer_reg <= 4'd1) begin
                            state <= NS_GREEN;
                            timer_reg <= 4'd5;
                        end else begin
                            timer_reg <= timer_reg - 4'd1;
                        end
                    end
                endcase
            end
        end
    end

    // Output logic (Moore)
    always_comb begin
        ns_g = 0; ns_y = 0; ns_r = 0;
        ew_g = 0; ew_y = 0; ew_r = 0;
        case (state)
            NS_GO, NS_GREEN:   begin ns_g = 1; ew_r = 1; end
            NS_WARN, NS_YELLOW: begin ns_y = 1; ew_r = 1; end
            EW_GO, EW_GREEN:   begin ns_r = 1; ew_g = 1; end
            EW_WARN, EW_YELLOW: begin ns_r = 1; ew_y = 1; end
        endcase
    end

    assign timer = timer_reg;
endmodule
