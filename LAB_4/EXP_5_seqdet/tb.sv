`timescale 1ns/1ps
module tb;
    logic clk = 1'b0;
    logic rst = 1'b1;
    logic x = 1'b0;
    logic z;
    seq_det_3 u (.clk(clk), .rst(rst), .x(x), .z(z));
    int bad = 0;
    // reference model
    int ones = 0, zeros = 0;
    function automatic logic exp_z();
        return (ones % 3 == 0) && (zeros % 2 == 0) && (zeros >= 2);
    endfunction
    // sequence: 1,1,1,0,0 -> after 5 bits: 3 ones, 2 zeros -> z=1 on last bit
    logic seq [0:4] = '{1,1,1,0,0};
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        rst = 1'b1;
        repeat (2) @(posedge clk);
        rst = 1'b0;
        ones = 0; zeros = 0;
        for (int i = 0; i < 5; i++) begin
            x = seq[i];
            if (x) ones++; else zeros++;
            @(posedge clk);
            #1;
            if (z !== exp_z()) begin
                bad++;
            end
        end
        // extra: feed more bits, keep checking
        // 1,0,1,0 -> cumulative 4 ones, 4 zeros -> z=1 (4%3=1? 4%3=1 not div) -> z=0
        begin
            logic extra [0:3] = '{1,0,1,0};
            for (int i = 0; i < 4; i++) begin
                x = extra[i];
                if (x) ones++; else zeros++;
                @(posedge clk);
                #1;
                if (z !== exp_z()) begin
                    bad++;
                end
            end
        end
        if (bad == 0) $display("ALL TESTS PASS");
        else          $display("FAIL: %0d errors", bad);
        $finish;
    end
    always #5 clk = ~clk;
endmodule
