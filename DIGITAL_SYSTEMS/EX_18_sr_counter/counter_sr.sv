`timescale 1ns/1ps
// Cau 4: 3-bit counter with SR-FF
// Counting sequence: 000 -> 111 -> 110 -> 101 -> 001 -> 000 (Modulo 5)
// SR-FF: negative edge clock, Preset active high, Clear active low
// Hint: S = D, R = NOT(D) (SR-FF behaves like D-FF)

// SR Flip-Flop (negative edge, preset active high, clear active low)
module sr_ff (
    input  logic clk,
    input  logic preset,
    input  logic clear_n,
    input  logic s, r,
    output logic q
);
    initial q = 1'b0;
    always_ff @(negedge clk or posedge preset or negedge clear_n) begin
        if (preset)       q <= 1'b1;
        else if (!clear_n) q <= 1'b0;
        else if (s && !r)  q <= 1'b1;
        else if (!s && r)  q <= 1'b0;
    end
endmodule

// 3-bit counter using SR-FF
module counter_sr (
    input  logic clk, rst_n, preset,
    output logic [2:0] Q
);
    logic D2, D1, D0;
    logic S2, R2, S1, R1, S0, R0;

    always_comb begin
        case (Q)
            3'b000: begin D2=1; D1=1; D0=1; end
            3'b111: begin D2=1; D1=1; D0=0; end
            3'b110: begin D2=1; D1=0; D0=1; end
            3'b101: begin D2=0; D1=0; D0=1; end
            3'b001: begin D2=0; D1=0; D0=0; end
            default: begin D2=0; D1=0; D0=0; end
        endcase
    end

    assign S2 = D2; assign R2 = ~D2;
    assign S1 = D1; assign R1 = ~D1;
    assign S0 = D0; assign R0 = ~D0;

    sr_ff ff2 (.clk(clk), .preset(preset), .clear_n(rst_n), .s(S2), .r(R2), .q(Q[2]));
    sr_ff ff1 (.clk(clk), .preset(preset), .clear_n(rst_n), .s(S1), .r(R1), .q(Q[1]));
    sr_ff ff0 (.clk(clk), .preset(preset), .clear_n(rst_n), .s(S0), .r(R0), .q(Q[0]));
endmodule
