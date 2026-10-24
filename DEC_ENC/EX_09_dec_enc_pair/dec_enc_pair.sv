`timescale 1ns/1ps
// Decoder-Encoder pair: encode then decode, verify round trip
module dec_enc_pair (
    input  logic [2:0] din,
    output logic [2:0] dout,
    output logic       valid
);
    logic [7:0] decoded;
    dec3to8 u_dec (.a(din), .en(1'b1), .y(decoded));
    prienc8to3 u_enc (.d(decoded), .y(dout), .valid(valid));
endmodule
