`timescale 1ns/1ps
// Priority Encoder 8-to-3 (active-low inputs, like 74LS148)
// Priority: i[7] > i[6] > ... > i[0]
module prienc8to3 (
    input  logic [7:0] i_n,   // active low inputs
    output logic [2:0] a,     // binary code (active low sense)
    output logic       gs_n,  // group select (active low)
    output logic       eo_n   // enable out (active low)
);
    always_comb begin
        if (i_n == 8'hFF) begin
            a = 3'b111; gs_n = 1'b1; eo_n = 1'b0;
        end else begin
            gs_n = 1'b0; eo_n = 1'b1;
            if (!i_n[0]) a = 3'b111;
            else if (!i_n[1]) a = 3'b110;
            else if (!i_n[2]) a = 3'b101;
            else if (!i_n[3]) a = 3'b100;
            else if (!i_n[4]) a = 3'b011;
            else if (!i_n[5]) a = 3'b010;
            else if (!i_n[6]) a = 3'b001;
            else a = 3'b000;
        end
    end
endmodule
