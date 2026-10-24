`timescale 1ns/1ps
// MUX-DEMUX pair: routes one of 4 inputs to one of 4 outputs
module mux_demux_pair (
    input  logic [3:0] din,
    input  logic [1:0] sel_mux,
    input  logic [1:0] sel_demux,
    output logic [3:0] dout,
    output logic       routed
);
    logic mid;
    mux4to1 u_mux (.d(din), .sel(sel_mux), .y(mid));
    demux1to4 u_demux (.d(mid), .sel(sel_demux), .y(dout));
    assign routed = mid;
endmodule
