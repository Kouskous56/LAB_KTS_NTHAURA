`timescale 1ns/1ps
// SR Latch: level sensitive, active high
module sr_latch (
    input  logic s, r,
    output logic q, q_n
);
    always_comb begin
        if (s && !r) begin q = 1; q_n = 0; end
        else if (!s && r) begin q = 0; q_n = 1; end
        else if (!s && !r) begin /* hold */ end
        else begin q = 1'bx; q_n = 1'bx; end  // invalid: S=R=1
    end
endmodule
