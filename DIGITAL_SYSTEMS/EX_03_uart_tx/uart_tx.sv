`timescale 1ns/1ps
// UART Transmitter: 8N1 (8 data bits, no parity, 1 stop bit)
module uart_tx (
    input  logic clk, rst,
    input  logic tx_start,
    input  logic [7:0] tx_data,
    output logic tx,
    output logic busy
);
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
    state_t state;
    logic [2:0] bit_cnt;
    logic [7:0] data_reg;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE; tx <= 1'b1; busy <= 1'b0; bit_cnt <= 3'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (tx_start) begin state <= START; data_reg <= tx_data; tx <= 1'b0; busy <= 1'b1; end
                end
                START: begin state <= DATA; bit_cnt <= 3'd0; tx <= data_reg[0]; end
                DATA: begin
                    if (bit_cnt == 3'd7) begin state <= STOP; tx <= 1'b1; end
                    else begin bit_cnt <= bit_cnt + 3'd1; tx <= data_reg[bit_cnt + 3'd1]; end
                end
                STOP: begin state <= IDLE; tx <= 1'b1; busy <= 1'b0; end
            endcase
        end
    end
endmodule
