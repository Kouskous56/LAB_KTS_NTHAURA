`timescale 1ns/1ps
// 74165 - 8-bit parallel-load shift register (serial out)
module ic_74165 (
    input  logic       clk, sh_ld_n, clk_inh,
    input  logic       ser,
    input  logic [7:0] d,
    output logic       qh, qh_n
);
    logic [7:0] regv;
    always @(posedge clk) begin
        if (!clk_inh) begin
            if (!sh_ld_n) regv <= d;
            else regv <= {regv[6:0], ser};
        end
    end
    assign qh = regv[7];
    assign qh_n = ~regv[7];
endmodule
