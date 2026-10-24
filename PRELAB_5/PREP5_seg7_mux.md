# PREP 5 — Multiplex 7 đoạn 2 digit

## Multiplex hai digit

Tám digit dùng chung các cathode CA…CG; chỉ digit có anode được bật mới hiển thị mẫu hiện tại.
Quy trình mỗi lần quét:

1. Tắt tất cả anode (`AN=8'hFF`) để tránh ghosting.
2. Đặt cathode pattern cho digit cần hiển thị.
3. Bật đúng một anode (`AN=8'b1111_1110` cho AN0 hoặc `8'b1111_1101` cho AN1).
4. Sau một khoảng ngắn, tắt digit hiện hành và lặp lại với digit còn lại.

Manual mẫu dùng refresh counter 18-bit và `refresh_tick=refresh_counter[17]`.
Với clock 100 MHz, bit 17 đổi trạng thái mỗi `2^17=131,072` chu kỳ, khoảng 1.31 ms;
mỗi digit bật xấp xỉ thời gian này, hai digit được làm mới hoàn chỉnh khoảng mỗi 2.62 ms (~382 Hz).
Đây thường đủ nhanh để mắt thấy hiển thị ổn định.

## Mã cathode active-low, thứ tự `{g,f,e,d,c,b,a}`

| Hex | Pattern | Hex | Pattern |
|---:|:---:|---:|:---:|
| 0 | 1000000 | 8 | 0000000 |
| 1 | 1111001 | 9 | 0010000 |
| 2 | 0100100 | A | 0001000 |
| 3 | 0110000 | b | 0000011 |
| 4 | 0011001 | C | 1000110 |
| 5 | 0010010 | d | 0100001 |
| 6 | 0000010 | E | 0000110 |
| 7 | 1111000 | F | 0001110 |
| Blank | 1111111 | | |

Manual đưa mẫu BCD 0–9, với `default` blank. Không nhất thiết phải hiển thị A–F.

## Code SystemVerilog (seg7 scan)

```systemverilog
module seg7_scan (
    input  logic clk,
    input  logic [3:0] digit0,  // right digit
    input  logic [3:0] digit1,  // left digit
    output logic [7:0] an,
    output logic [6:0] seg       // {g,f,e,d,c,b,a} active low
);
    logic [17:0] refresh_counter;
    logic refresh_tick;
    logic [3:0] current_digit;

    always_ff @(posedge clk) begin
        refresh_counter <= refresh_counter + 1'b1;
    end

    assign refresh_tick = refresh_counter[17];

    always_comb begin
        if (refresh_tick) begin
            an = 8'b1111_1101;  // enable digit 1 (AN1)
            current_digit = digit1;
        end else begin
            an = 8'b1111_1110;  // enable digit 0 (AN0)
            current_digit = digit0;
        end
    end

    // BCD to 7-seg (active low)
    always_comb begin
        case (current_digit)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            default: seg = 7'b1111111;  // blank
        endcase
    end
endmodule
```

## Bình luận
- Đầu nối Master XDC có các port scalar riêng `CA,CB,CC,CD,CE,CF,CG`;
  nếu core có `seg[6:0]={g,f,e,d,c,b,a}`, wrapper cần nối `CG=seg[6]`, …, `CA=seg[0]`.
- Tránh nối `seg[6:0]` trực tiếp theo thứ tự không kiểm tra.
- Comment manual nói đổi digit mỗi 4–5 ms/500 Hz nhưng không khớp chính xác giá trị bit[17];
  nếu cần 4–5 ms mỗi digit, chọn divisor tương ứng và tính lại.
