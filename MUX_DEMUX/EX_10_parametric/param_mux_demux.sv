`timescale 1ns/1ps
// Parametric N-to-1 MUX
module mux_param #(parameter N = 8) (
    input  logic [N-1:0] d,
    input  logic [$clog2(N)-1:0] sel,
    output logic y
);
    assign y = d[sel];
endmodule

// Parametric 1-to-N DEMUX
module demux_param #(parameter N = 8) (
    input  logic d,
    input  logic [$clog2(N)-1:0] sel,
    output logic [N-1:0] y
);
    always_comb begin
        y = '0;
        y[sel] = d;
    end
endmodule
