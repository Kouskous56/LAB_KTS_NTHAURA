`timescale 1ns/1ps
module tb;
    logic A,B,C,F;
    f_using_decoder dut (.A(A),.B(B),.C(C),.F(F));
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $display("start test");
        for (int i=0;i<8;i++) begin
            {A,B,C}=i[2:0]; #1;
            $display("ABC=%b%b%b F=%b (exp %b)", A,B,C, F, A & ~C);
        end
        $display("done");
        $finish;
    end
endmodule
