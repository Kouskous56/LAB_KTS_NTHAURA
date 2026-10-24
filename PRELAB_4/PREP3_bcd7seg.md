# PREP 3 — BCD sang 7-segment common-anode

## Đặc tả

Đầu vào I3…I0 là số BCD; output bus nên quy ước `seg[6:0]={g,f,e,d,c,b,a}` để đúng thứ tự literal trong manual.
LOW bật segment. Mẫu phổ biến cho chữ số 0–9 theo `gfedcba`:

| Decimal | I3I2I1I0 | Bật các đoạn | `seg[6:0]` active-low |
|---:|:---:|---|:---:|
| 0 | 0000 | a,b,c,d,e,f | 1000000 |
| 1 | 0001 | b,c | 1111001 |
| 2 | 0010 | a,b,d,e,g | 0100100 |
| 3 | 0011 | a,b,c,d,g | 0110000 |
| 4 | 0100 | b,c,f,g | 0011001 |
| 5 | 0101 | a,c,d,f,g | 0010010 |
| 6 | 0110 | a,c,d,e,f,g | 0000010 |
| 7 | 0111 | a,b,c | 1111000 |
| 8 | 1000 | a,b,c,d,e,f,g | 0000000 |
| 9 | 1001 | a,b,c,d,f,g | 0010000 |

Các literal trên giả định thứ tự `{g,f,e,d,c,b,a}` và active-low. Cần đối chiếu bảng/board của lớp vì đảo thứ tự bit bus là lỗi rất thường gặp.
Với input A–F không phải BCD hợp lệ, hãy gán blank `7'b1111111` hoặc theo yêu cầu cụ thể; đừng để output không gán. Manual gợi ý `case`; trong `always_comb`, dùng blocking assignment và có `default`.

Trên Nexys A7, ngoài segment cathodes còn phải điều khiển anodes. Để hiển thị một chữ số ở vị trí phải cùng cấu hình của manual: `AN[0]=0`, `AN[7:1]=1`; các bit `CA..CG` phải gán đúng các segment. Không để các digit khác được enable đồng thời nếu dữ liệu chỉ dành cho một digit.

## Code SystemVerilog

```systemverilog
module bcd7seg (
    input  logic [3:0] I,
    output logic [6:0] seg  // seg[6:0] = {g,f,e,d,c,b,a}, active low
);
    always_comb begin
        case (I)
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
            default: seg = 7'b1111111;  // blank for A-F
        endcase
    end
endmodule
```
