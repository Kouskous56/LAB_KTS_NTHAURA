# PREP 1 — Hàm SOP (Preparation 1)

## Mục tiêu
Viết SystemVerilog mô tả hàm Boolean cho trước.

## Hàm (theo manual)

Theo cách đọc công thức trong Preparation 1:

```text
f = x̄yz + (xy)̄z + xy
  = (xy)̄z + xy
  = z + xy
  = Σm(1,3,5,6,7)
```

`x̄y` kéo theo `(xy)̄`, nên số hạng `x̄yz` được hấp thụ bởi `(xy)̄z`. Cẩn thận: gạch phủ trên `xy` nghĩa là NOT của tích `xy`, không phải `x̄ȳ`.

| x | y | z | f = z + xy |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 0 |
| 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 1 |
| 1 | 1 | 1 | 1 |

Vector `000→111`: `01010111`.

## Code SystemVerilog

```systemverilog
module func_ep_1 (
    input  logic x, y, z,
    output logic f
);
    // f = z + (x & y)
    assign f = z | (x & y);
endmodule
```

## Bình luận
- Mạch rút gọn: AND `q = x·y`, rồi OR `f = z + q`.
- RTL Viewer sau synthesis có thể tối giản khác sơ đồ cổng ban đầu nhưng phải tương đương về chức năng.
- Kiểm tra tất cả 8 tổ hợp trước khi nạp board.
