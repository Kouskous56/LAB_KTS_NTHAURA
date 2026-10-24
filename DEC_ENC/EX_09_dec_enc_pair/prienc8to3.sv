`timescale 1ns/1ps
module prienc8to3 (
    input  logic [7:0] d,
    output logic [2:0] y,
    output logic      valid
);
    always_comb begin
        if (d[7]) begin y = 3'b111; valid = 1'b1; end
        else if (d[6]) begin y = 3'b110; valid = 1'b1; end
        else if (d[5]) begin y = 3'b101; valid = 1'b1; end
        else if (d[4]) begin y = 3'b100; valid = 1'b1; end
        else if (d[3]) begin y = 3'b011; valid = 1'b1; end
        else if (d[2]) begin y = 3'b010; valid = 1'b1; end
        else if (d[1]) begin y = 3'b001; valid = 1'b1; end
        else if (d[0]) begin y = 3'b000; valid = 1'b1; end
        else begin y = 3'b000; valid = 1'b0; end
    end
endmodule
