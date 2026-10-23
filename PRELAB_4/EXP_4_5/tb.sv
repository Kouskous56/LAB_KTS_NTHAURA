`timescale 1ns/1ps
module tb;
    logic       clk = 1'b0;
    logic       rst = 1'b1;
    logic       x   = 1'b0;
    logic [1:0] y;
    fsm_4state_core u (.clk(clk), .rst(rst), .x_in(x), .y_out(y));
    int bad = 0;

    function automatic logic [1:0] nxt(input logic [1:0] s, input logic xi);
        case (s)
            2'b00: return xi ? 2'b01 : 2'b00;
            2'b01: return xi ? 2'b00 : 2'b10;
            2'b10: return xi ? 2'b10 : 2'b11;
            2'b11: return xi ? 2'b11 : 2'b00;
            default: return 2'b00;
        endcase
    endfunction
    function automatic logic [1:0] yof(input logic [1:0] s);
        case (s)
            2'b00: return 2'b00;
            2'b01: return 2'b10;
            2'b10: return 2'b11;
            2'b11: return 2'b01;
            default: return 2'b00;
        endcase
    endfunction

    logic seq [0:10] = '{1,0,0,1,0,1,1,0,1,0,1};

    initial begin
        logic [1:0] st;
        logic [1:0] old;
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        st = 2'b00;
        repeat (2) @(posedge clk);
        rst = 1'b0;
        for (int i = 0; i < 11; i++) begin
            x = seq[i];
            old = st;
            @(posedge clk);
            #1;
            st = nxt(old, x);
            if (y !== yof(st)) begin
                bad++;
                $display("FAIL step %0d: x=%b -> state=%b y=%b (exp %b)", i, x, st, y, yof(st));
            end
        end
        if (bad == 0) $display("ALL TESTS PASS");
        else          $display("FAIL: %0d errors", bad);
        $finish;
    end
    always #5 clk = ~clk;
endmodule
