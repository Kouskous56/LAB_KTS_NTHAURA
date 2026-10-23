`timescale 1ns/1ps
// 74193 - 4-bit up/down binary counter (async clear, sync load, separate up/down clocks)
module ic_74193 (
    input  logic       clr_n, ld_n,
    input  logic       up_clk, down_clk,
    input  logic [3:0] d,
    output logic [3:0] q,
    output logic       carry_n, borrow_n
);
    always @(negedge clr_n) q <= 4'd0;
    always @(posedge up_clk) begin
        if (clr_n && !ld_n) q <= d;
        else if (clr_n && ld_n) q <= q + 4'd1;
    end
    always @(posedge down_clk) begin
        if (clr_n && !ld_n) q <= d;
        else if (clr_n && ld_n) q <= q - 4'd1;
    end
    assign carry_n = ~(q == 4'hF);   // active low carry on overflow
    assign borrow_n = ~(q == 4'h0);  // active low borrow on underflow
endmodule
