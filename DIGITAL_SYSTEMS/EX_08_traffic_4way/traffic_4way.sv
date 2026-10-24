`timescale 1ns/1ps
// 4-way Traffic Light Controller
module traffic_4way (
    input  logic clk, rst,
    input  logic tick_1s,
    output logic [1:0] ns, ew,  // 00=red, 01=green, 10=yellow
    output logic [3:0] timer
);
    typedef enum logic [2:0] {NS_G, NS_Y, EW_G, EW_Y, NS_G2, NS_Y2, EW_G2, EW_Y2} state_t;
    state_t state;
    logic [3:0] timer_reg;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin state <= NS_G; timer_reg <= 4'd5; end
        else if (tick_1s) begin
            case (state)
                NS_G:  begin if (timer_reg==4'd1) begin state<=NS_Y; timer_reg<=4'd2; end else timer_reg<=timer_reg-4'd1; end
                NS_Y:  begin if (timer_reg==4'd1) begin state<=EW_G; timer_reg<=4'd5; end else timer_reg<=timer_reg-4'd1; end
                EW_G:  begin if (timer_reg==4'd1) begin state<=EW_Y; timer_reg<=4'd2; end else timer_reg<=timer_reg-4'd1; end
                EW_Y:  begin if (timer_reg==4'd1) begin state<=NS_G; timer_reg<=4'd5; end else timer_reg<=timer_reg-4'd1; end
            endcase
        end
    end

    always_comb begin
        ns = 2'b00; ew = 2'b00;
        case (state)
            NS_G:  begin ns=2'b01; ew=2'b00; end
            NS_Y:  begin ns=2'b10; ew=2'b00; end
            EW_G:  begin ns=2'b00; ew=2'b01; end
            EW_Y:  begin ns=2'b00; ew=2'b10; end
        endcase
    end
    assign timer = timer_reg;
endmodule
