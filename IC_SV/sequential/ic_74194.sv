`timescale 1ns/1ps
// 74194 - 4-bit bidirectional universal shift register
// S1,S0: 00=hold, 01=shift right, 10=shift left, 11=parallel load
module ic_74194 (
    input  logic       clk, clr_n,
    input  logic       s1, s0,
    input  logic       sil, sir,   // serial in left/right
    input  logic [3:0] d,
    output logic [3:0] q
);
    always @(posedge clk or negedge clr_n) begin
        if (!clr_n) q <= 4'b0;
        else begin
            case ({s1,s0})
                2'b00: q <= q;
                2'b01: q <= {sir, q[3:1]};
                2'b10: q <= {q[2:0], sil};
                2'b11: q <= d;
            endcase
        end
    end
endmodule
