`timescale 1ns/1ps
// Nexys A7: SW[2]=x, SW[1]=y, SW[0]=z ; LED[0]=f
// Implement via 74LS151: D0=0,D1=1,D2=1,D3=0,D4=1,D5=0,D6=0,D7=1, Strobe=0
module top_module (
    input  logic [2:0]  SW,
    output logic [15:0] LED
);
    logic x,y,z,f;
    assign x = SW[2]; assign y = SW[1]; assign z = SW[0];
    logic [7:0] d = 8'b10010110; // D7..D0
    logic g_n = 1'b0;
    ic_74151 mux (.d(d), .s({x,y,z}), .g_n(g_n), .y(f), .w());
    assign LED[0]    = f;
    assign LED[15:1] = 15'b0;
endmodule
