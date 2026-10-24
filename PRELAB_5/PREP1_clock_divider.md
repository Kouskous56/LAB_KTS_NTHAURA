# PREP 1 — Bộ chia clock 100 MHz → 1 Hz

## Tính toán

Sóng vuông 1 Hz có chu kỳ 1 s: HIGH 0.5 s, LOW 0.5 s.
Đảo output sau mỗi:

    100,000,000 cycles/s × 0.5 s = 50,000,000 cycles

Counter chạy từ 0 đến 49,999,999, rồi về 0 và đảo `out_signal`.
26 bit là đủ vì `2^25=33,554,432 < 50,000,000 < 2^26`.

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

## Mô phỏng
Dùng parameter override với DIVISOR nhỏ (gợi ý 4) trong testbench.
**Quan trọng:** khôi phục 50,000,000 cho cấu hình board.

## Bình luận
- 26 bit là đủ vì `2^25=33,554,432` chưa đủ, còn `2^26=67,108,864` đủ.
- BTNC trên board là reset theo wiring/logic active-high.
- N?u dùng square wave 1 Hz làm clock, cạnh lên chỉ xuất hiện 1 lần/giây.
  Tốt hơn là tạo pulse enable riêng 1 chu kỳ mỗi giây.
