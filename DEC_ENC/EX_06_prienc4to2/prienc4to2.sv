`timescale 1ns/1ps
// Priority Encoder 4-to-2: highest priority input wins
// Priority: d[3] > d[2] > d[1] > d[0]
module prienc4to2 (
    input  logic [3:0] d,
    output logic [1:0] y,
    output logic       valid
);
    always_comb begin
        if (d[3]) begin y = 2'b11; valid = 1'b1; end
        else if (d[2]) begin y = 2'b10; valid = 1'b1; end
        else if (d[1]) begin y = 2'b01; valid = 1'b1; end
        else if (d[0]) begin y = 2'b00; valid = 1'b1; end
        else begin y = 2'b00; valid = 1'b0; end
    end
endmodule
