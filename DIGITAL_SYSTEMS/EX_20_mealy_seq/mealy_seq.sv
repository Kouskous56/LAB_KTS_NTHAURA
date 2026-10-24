`timescale 1ns/1ps
// Cau 6: Mealy sequential circuit
// 2 inputs: E (enable), X (data)
// 1 output: Z
// E=1: detect sequences "110" or "1111" -> Z=1
// E=0: hold state, Z=0
// Mealy: Z depends on state + input

module mealy_seq (
    input  logic clk, rst,
    input  logic E, X,
    output logic Z
);
    // States
    typedef enum logic [1:0] {S0, S1, S2, S4} state_t;
    // S0: start (no prefix)
    // S1: received "1"
    // S2: received "11"
    // S4: received "111"
    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (rst) state <= S0;
        else if (E) state <= next_state;
        // if E=0, hold state
    end

    always_comb begin
        next_state = state;
        Z = 1'b0;
        if (E) begin
            case (state)
                S0: begin
                    if (X) begin next_state = S1; end
                    else   begin next_state = S0; end
                    Z = 1'b0;
                end
                S1: begin
                    if (X) begin next_state = S2; end
                    else   begin next_state = S0; end
                    Z = 1'b0;
                end
                S2: begin
                    if (X) begin next_state = S4; Z = 1'b0; end
                    else   begin next_state = S0; Z = 1'b1; end  // "110" matched
                end
                S4: begin
                    if (X) begin next_state = S4; Z = 1'b1; end  // "1111" matched
                    else   begin next_state = S0; Z = 1'b1; end  // "110" matched (suffix)
                end
            endcase
        end
    end
endmodule
