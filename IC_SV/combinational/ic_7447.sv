`timescale 1ns/1ps
// 7447 - BCD to 7-segment decoder (common anode, active-low outputs, with ripple blanking)
module ic_7447 (
    input  logic [3:0] bcd,
    input  logic       rbi_n,    // ripple blanking input (active low)
    output logic [6:0] seg_n,    // {g,f,e,d,c,b,a} active low
    output logic       rbo_n     // ripple blanking output
);
    // standard 7447 patterns (active low: 0 = segment on)
    function automatic logic [6:0] pat(input logic [3:0] v);
        case (v)
            4'd0: return 7'b1000000; 4'd1: return 7'b1111001; 4'd2: return 7'b0100100;
            4'd3: return 7'b0110000; 4'd4: return 7'b0011001; 4'd5: return 7'b0010010;
            4'd6: return 7'b0000010; 4'd7: return 7'b1111000; 4'd8: return 7'b0000000;
            4'd9: return 7'b0010000; default: return 7'b1111111; // blank for 10-15
        endcase
    endfunction
    always @(*) begin
        if (bcd == 4'd0 && !rbi_n) begin seg_n = 7'b1111111; rbo_n = 1'b0; end  // blank
        else begin seg_n = pat(bcd); rbo_n = 1'b1; end
    end
endmodule
