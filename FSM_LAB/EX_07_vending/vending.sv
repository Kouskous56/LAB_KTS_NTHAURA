`timescale 1ns/1ps
// Vending machine FSM: insert coins, select product, dispense
module vending (
    input  logic clk, rst,
    input  logic coin, select,
    output logic dispense, change
);
    typedef enum logic [1:0] {IDLE, COIN, SELECT, DISPENSE} state_t;
    state_t state;

    always_ff @(posedge clk) begin
        if (rst) state <= IDLE;
        else begin
            case (state)
                IDLE:    if (coin) state <= COIN;
                COIN:    if (select) state <= SELECT; else if (coin) state <= COIN;
                SELECT:  state <= DISPENSE;
                DISPENSE: state <= IDLE;
            endcase
        end
    end

    always_comb begin
        dispense = (state == DISPENSE);
        change = 1'b0;  // simplified: no change
    end
endmodule
