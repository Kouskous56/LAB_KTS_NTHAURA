# EX_01 — Decoder 2-to-4 (active high)

## Khái niệm
Decoder 2-to-4 biến mã 2-bit (a[1:0]) thành một trong 4 đầu ra (y[0..3]).
Chỉ có một đầu ra ở mức 1 tại một thời điểm (one-hot).

## Truth table

| a1 | a0 | y3 | y2 | y1 | y0 |
|---|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 | 1 |
| 0 | 1 | 0 | 0 | 1 | 0 |
| 1 | 0 | 0 | 1 | 0 | 0 |
| 1 | 1 | 1 | 0 | 0 | 0 |

## Code SystemVerilog
```systemverilog
module dec2to4 (input logic [1:0] a, output logic [3:0] y);
    always_comb begin
        y = 4'b0;
        y[a] = 1'b1;
    end
endmodule
```

## Ứng dụng
- Giải mã địa chỉ (address decoding).
- Chọn một trong nhiều thiết bị ngoại vi.
- Xây dựng decoder lớn hơn (3-to-8, 4-to-16).
