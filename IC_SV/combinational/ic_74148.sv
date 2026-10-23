`timescale 1ns/1ps
// 74148 - 8-to-3 priority encoder (active-low inputs/outputs)
module ic_74148 (
    input  logic [7:0] i_n,   // active low inputs
    output logic [2:0] a,     // binary code of highest priority (active low sense)
    output logic       gs_n,  // group select (active low)
    output logic       eo_n   // enable out (active low)
);
    always @(*) begin
        // find highest priority (lowest index) active-low input
        if (i_n == 8'hFF) begin a = 3'b111; gs_n = 1; eo_n = 0; end
        else begin
            gs_n = 0; eo_n = 1;
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
