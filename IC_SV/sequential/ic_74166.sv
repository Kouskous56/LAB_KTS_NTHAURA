`timescale 1ns/1ps
// 74166 - 8-bit parallel-load shift register (serial out, with clock inhibit)
module ic_74166 (
    input  logic       clk, sh_ld_n, clk_inh, clr_n,
    input  logic       ser,
    input  logic [7:0] d,
    output logic       qh
);
    logic [7:0] regv;
    always @(posedge clk or negedge clr_n) begin
        if (!clr_n) regv <= 8'b0;
        else if (!clk_inh) begin
            if (!sh_ld_n) regv <= d;
            else regv <= {regv[6:0], ser};
        end
    end
    assign qh = regv[7];
endmodule
