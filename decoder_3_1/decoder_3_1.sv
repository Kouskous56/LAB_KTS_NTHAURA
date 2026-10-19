`timescale 1ns/1ps
module decoder_3_1 (
    input  logic E, X1, X0,
    output logic Y0, Y1, Y2, Y3
);
    // E=1 disables all outputs
    assign {Y3,Y2,Y1,Y0} = E ? 4'b0000 :
        (X1==0 && X0==0) ? 4'b0001 :
        (X1==0 && X0==1) ? 4'b0010 :
        (X1==1 && X0==0) ? 4'b0100 : 4'b1000;
endmodule
