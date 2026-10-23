`timescale 1ns/1ps
// 74163 - 4-bit synchronous binary counter
// CLR_N (sync clear, active low), LD_N (sync load), ENP/ENT (enable), RCO (ripple carry out)
module ic_74163 (
    input  logic       clk, clr_n, ld_n,
    input  logic       enp, ent,
    input  logic [3:0] d,
    output logic [3:0] q,
    output logic       rco
);
    always @(posedge clk) begin
        if (!clr_n) q <= 4'd0;
        else if (!ld_n) q <= d;
        else if (enp && ent) q <= q + 4'd1;
    end
    assign rco = (q == 4'hF) && ent;
endmodule
