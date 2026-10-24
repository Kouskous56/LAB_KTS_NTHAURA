`timescale 1ns/1ps
module tb;
    logic clk=0, rst=1;
    logic X=0;
    logic Z1, Z2;
    logic [1:0] QAQB;

    seq_pla u (.clk(clk), .rst(rst), .X(X), .Z1(Z1), .Z2(Z2), .QAQB(QAQB));

    int bad = 0;

    // State encoding: S0=10, S1=11, S2=00, S3=01
    // Function to convert QAQB to state name
    function string state_name(logic [1:0] s);
        case (s)
            2'b10: return "S0";
            2'b11: return "S1";
            2'b00: return "S2";
            2'b01: return "S3";
            default: return "??";
        endcase
    endfunction

    task automatic tick();
        clk=1; #5; clk=0; #5;
    endtask

    initial begin
        rst=1; tick(); rst=0;
        // After reset: QA=0, QB=0 -> S2
        $display("INIT: state=%s (QAQB=%b)", state_name(QAQB), QAQB);

        // Test from S2 (00): X=0 -> S3 (01), Z2=1
        X = 0; tick();
        $display("S2 X=0: state=%s Z1=%b Z2=%b", state_name(QAQB), Z1, Z2);
        if (QAQB !== 2'b01) begin bad++; $display("FAIL: exp S3(01), got %b", QAQB); end
        if (Z2 !== 1) begin bad++; $display("FAIL Z2: exp 1, got %b", Z2); end

        // From S3 (01): X=1 -> S1 (11), Z2=1
        X = 1; tick();
        $display("S3 X=1: state=%s Z1=%b Z2=%b", state_name(QAQB), Z1, Z2);
        if (QAQB !== 2'b11) begin bad++; $display("FAIL: exp S1(11), got %b", QAQB); end

        // From S1 (11): X=0 -> S1 (11), Z2=0
        X = 0; tick();
        $display("S1 X=0: state=%s Z1=%b Z2=%b", state_name(QAQB), Z1, Z2);
        if (QAQB !== 2'b11) begin bad++; $display("FAIL: exp S1(11), got %b", QAQB); end
        if (Z2 !== 0) begin bad++; $display("FAIL Z2: exp 0, got %b", Z2); end

        // From S1 (11): X=1 -> S0 (10), Z2=1
        X = 1; tick();
        $display("S1 X=1: state=%s Z1=%b Z2=%b", state_name(QAQB), Z1, Z2);
        if (QAQB !== 2'b10) begin bad++; $display("FAIL: exp S0(10), got %b", QAQB); end

        // From S0 (10): X=0 -> S3 (01), Z2=1
        X = 0; tick();
        $display("S0 X=0: state=%s Z1=%b Z2=%b", state_name(QAQB), Z1, Z2);
        if (QAQB !== 2'b01) begin bad++; $display("FAIL: exp S3(01), got %b", QAQB); end

        // From S3 (01): X=0 -> S0 (10), Z2=1 (using our interpretation)
        X = 0; tick();
        $display("S3 X=0: state=%s Z1=%b Z2=%b", state_name(QAQB), Z1, Z2);
        if (QAQB !== 2'b10) begin bad++; $display("FAIL: exp S0(10), got %b", QAQB); end

        // Verify Z1 (Moore) for S0
        if (Z1 !== 1) begin bad++; $display("FAIL Z1 S0: exp 1, got %b", Z1); end

        if (bad == 0) $display("EX_21 ALL TESTS PASS");
        else          $display("EX_21 FAIL: %0d", bad);
        $finish;
    end
endmodule
