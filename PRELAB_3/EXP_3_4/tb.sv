`timescale 1ns/1ps
module tb;
    logic clk = 1'b0, clr = 1'b1, X = 1'b0;
    logic [1:0] S;
    fsm_fig34 u (.clk(clk), .clr(clr), .X(X), .S(S));

    int bad = 0;
    logic [1:0] cur, nxt;

    // Figure 3.4 next state
    function automatic logic [1:0] next_state(input logic [1:0] ps, input logic x);
        case ({ps, x})
            {2'b00, 1'b0}: return 2'b00;  // A -> A
            {2'b00, 1'b1}: return 2'b01;  // A -> B
            {2'b01, 1'b0}: return 2'b00;  // B -> A
            {2'b01, 1'b1}: return 2'b11;  // B -> D
            {2'b10, 1'b0}: return 2'b00;  // C -> A
            {2'b10, 1'b1}: return 2'b01;  // C -> B
            {2'b11, 1'b0}: return 2'b00;  // D -> A
            {2'b11, 1'b1}: return 2'b10;  // D -> C
        endcase
    endfunction

    task automatic tick(input logic x);
        begin
            X = x;
            #1 clk = 1'b1; #1 clk = 1'b0; #1;
        end
    endtask

    task automatic reset_a;
        begin
            clr = 1'b0; #1; clr = 1'b1; #1;
        end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");
        reset_a;
        if (S !== 2'b00) begin bad++; $display("FAIL reset S=%b", S); end
        else $display("reset -> A (00) OK");

        // walk every state and every input of the state table
        for (int i = 0; i < 8; i++) begin
            for (int x = 0; x < 2; x++) begin
                reset_a;
                case (i[1:0])
                    2'b00: ;                              // A
                    2'b01: tick(1'b1);                    // A -> B
                    2'b11: begin tick(1'b1); tick(1'b1); end // A -> B -> D
                    2'b10: begin tick(1'b1); tick(1'b1); tick(1'b1); end // -> C
                endcase
                cur = i[1:0];
                if (S !== cur) begin
                    bad++;
                    $display("FAIL reach %b, got %b", cur, S);
                end
                nxt = next_state(cur, x[0]);
                tick(x[0]);
                if (S !== nxt) begin
                    bad++;
                    $display("FAIL cur=%b X=%b S=%b exp=%b", cur, x[0], S, nxt);
                end else
                    $display("cur=%b X=%b -> %b OK", cur, x[0], S);
            end
        end

        // input sequence 0 1 1 0 0 0 1 from state A
        reset_a;
        $display("--- sequence 0 1 1 0 0 0 1 ---");
        $display("state before input 0 = %b (A)", S);
        tick(1'b0); $display("state before input 1 = %b (A)", S);
        tick(1'b1); $display("state before input 1 = %b (B)", S);
        tick(1'b1); $display("state before input 0 = %b (D)", S);
        tick(1'b0); $display("state before input 0 = %b (A)", S);
        tick(1'b0); $display("state before input 0 = %b (A)", S);
        tick(1'b0); $display("state before input 1 = %b (A)", S);
        tick(1'b1); $display("final state = %b (B)", S);

        if (bad == 0) $display("ALL TESTS PASS");
        else $display("%0d FAILURES", bad);
        $display("done");
        $finish;
    end
endmodule
