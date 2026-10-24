# PREP 4 — Bộ chia clock 100 MHz → 1 Hz

## Tính toán

Để tạo sóng vuông 1 Hz, đảo output mỗi 0.5 s:

    f_clk = 100,000,000 Hz
    cycles_per_toggle = 100,000,000 / (2 × 1 Hz) = 50,000,000

Counter chạy từ 0 tới 49,999,999, sau đó về 0 và đảo `out_signal`.
26 bit là đủ vì `2^25=33,554,432` chưa đủ, còn `2^26=67,108,864` đủ.

## Code SystemVerilog

```systemverilog
module clock_divider_core #(
    parameter int DIVISOR = 50_000_000
) (
    input  logic clk_in,
    input  logic rst_in,
    output logic out_signal
);
    localparam int CNT_W = $clog2(DIVISOR);
    logic [CNT_W-1:0] counter;

    always_ff @(posedge clk_in or posedge rst_in) begin
        if (rst_in) begin
            counter    <= '0;
            out_signal <= 1'b0;
        end else if (counter == DIVISOR - 1) begin
            counter    <= '0;
            out_signal <= ~out_signal;
        end else begin
            counter <= counter + 1'b1;
        end
    end
endmodule
```

## Top-level (Nexys A7-100T)

```systemverilog
module top_clock_div (
    input  logic        CLK100MHZ,
    input  logic        BTNC,       // reset active-high
    output logic [0:0]  LED
);
    clock_divider_core u (.clk_in(CLK100MHZ), .rst_in(BTNC), .out_signal(LED[0]));
endmodule
```

## Mô phỏng

Nếu dùng ngưỡng 50,000,000 phải mô phỏng 50 triệu cạnh mỗi lần đảo, rất lâu.
Dùng parameter override hoặc hằng nhỏ (manual gợi ý 4) trong testbench.
**Quan trọng:** khôi phục đúng 50,000,000 cho cấu hình board.
Nếu DIVISOR=4, đảo sau mỗi 4 clock; waveform có chu kỳ output 8 clock, không phải 4 clock.

## Bình luận
- 26 bit là đủ vì `2^25=33,554,432` chưa đủ, còn `2^26=67,108,864` đủ.
- Module mẫu trong PDF dùng `integer`; trên FPGA nên dùng vector độ rộng xác định, parameter cho ngưỡng và reset rõ ràng.
- BTNC trên board là reset theo wiring/logic active-high nêu trong mẫu; với các reset SW khác, phải tuân theo đúng polarity đặc tả.
