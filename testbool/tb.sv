`timescale 1ns/1ps

module tb;
    // Khai báo tín hiệu kết nối với DUT (Device Under Test)
    logic a, b, c;
    logic f;

    // Khởi tạo module f_bool
    f_bool dut (
        .a(a),
        .b(b),
        .c(c),
        .f(f)
    );

    // Biến dùng cho vòng lặp
    int i;

    initial begin
        // Cấu hình xuất file sóng (Waveform) cho các tool như Icarus/GTKWave
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        $display("--- BAT DAU TEST f_bool ---");
        $display(" a b c | f");
        $display("-------|---");

        // Quét toàn bộ 8 trường hợp từ 000 đến 111
        for (i = 0; i < 8; i = i + 1) begin
            // Gán giá trị cho a, b, c từ biến i
            {a, b, c} = i;
            
            // Đợi 1ns để logic ổn định
            #1; 
            
            // In kết quả
            $display(" %b %b %b | %b", a, b, c, f);
        end

        $display("--- KET THUC TEST ---");
        $finish;
    end
endmodule