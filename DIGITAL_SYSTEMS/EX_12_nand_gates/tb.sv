`timescale 1ns/1ps
module tb;
    // Test NOT
    logic x_not, z_not;
    not_from_nand u_not (.x(x_not), .z(z_not));

    // Test AND
    logic x_and, y_and, z_and;
    and_from_nand u_and (.x(x_and), .y(y_and), .z(z_and));

    // Test OR
    logic x_or, y_or, z_or;
    or_from_nand u_or (.x(x_or), .y(y_or), .z(z_or));

    // Test XOR
    logic x_xor, y_xor, z_xor;
    xor_from_nand u_xor (.x(x_xor), .y(y_xor), .z(z_xor));

    int bad = 0;

    initial begin
        // Test NOT
        for (int i = 0; i < 2; i++) begin
            x_not = i[0]; #10;
            if (z_not !== ~x_not) begin bad++; $display("FAIL NOT: x=%b z=%b", x_not, z_not); end
        end

        // Test AND
        for (int i = 0; i < 4; i++) begin
            x_and = i[0]; y_and = i[1]; #10;
            if (z_and !== (x_and & y_and)) begin bad++; $display("FAIL AND: x=%b y=%b z=%b", x_and, y_and, z_and); end
        end

        // Test OR
        for (int i = 0; i < 4; i++) begin
            x_or = i[0]; y_or = i[1]; #10;
            if (z_or !== (x_or | y_or)) begin bad++; $display("FAIL OR: x=%b y=%b z=%b", x_or, y_or, z_or); end
        end

        // Test XOR
        for (int i = 0; i < 4; i++) begin
            x_xor = i[0]; y_xor = i[1]; #10;
            if (z_xor !== (x_xor ^ y_xor)) begin bad++; $display("FAIL XOR: x=%b y=%b z=%b", x_xor, y_xor, z_xor); end
        end

        if (bad == 0) $display("EX_12 ALL TESTS PASS");
        else          $display("EX_12 FAIL: %0d", bad);
        $finish;
    end
endmodule
