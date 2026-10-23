`timescale 1ns/1ps
// 7489 - 64-bit (16x4) RAM
// Active-low write enable (WE_n), active-low output enable (OE_n).
// Data outputs are inverted (open collector) - modeled as normal here for clarity.
module ic_7489 (
    input  logic [3:0] addr,
    input  logic [3:0] din,
    input  logic       we_n,   // write enable, active low
    input  logic       oe_n,   // output enable, active low
    output logic [3:0] dout
);
    logic [3:0] mem [0:15];
    // write on WE_n low (level sensitive)
    always @(*) begin
        if (!we_n) mem[addr] = din;
    end
    assign dout = oe_n ? 4'bz : ~mem[addr];  // 7489 outputs are inverted
endmodule
