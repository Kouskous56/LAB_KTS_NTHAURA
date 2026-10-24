# PREP 2 — Hàm theo Table 2.1 (K-map)

## Mục tiêu
Suy ra biểu thức Boolean từ bảng chân lý Table 2.1.

## Bảng chân lý Table 2.1

Các hàng HIGH là `m0, m1, m3, m4, m7`, do đó:

```text
F = Σm(0,1,3,4,7)
  = ȳz̄ + yz + x̄z
```

Một nhóm tối thiểu tương đương là `F = ȳz̄ + yz + x̄ȳ`; hai cách chọn nhóm khác nhau nhưng bảng chân trị như nhau.

| xyz | 000 | 001 | 010 | 011 | 100 | 101 | 110 | 111 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| F | 1 | 1 | 0 | 1 | 1 | 0 | 0 | 1 |

Vector `000→111`: `11011001`.

## K-map

Các phép nhóm K-map nên theo Gray order `yz=00,01,11,10`; các ô ở hai mép cũng kề nhau. Dùng phương trình rút gọn, nhưng kiểm tra lại 8 giá trị trước khi viết RTL.

**Lỗi tham chiếu trong manual:** Procedure của Preparation 2 trỏ đến Figure 2.3, trong khi Table 2.1 định nghĩa một hàm khác; Figure 2.3 được giới thiệu ở Preparation 3. Với Preparation 2, lấy Table 2.1 làm đặc tả. Không dùng sơ đồ Figure 2.3 để thay bảng này.

## Code SystemVerilog

```systemverilog
module func_prep_2 (
    input  logic x, y, z,
    output logic f
);
    // F = ybar*zbar + y*z + xbar*z
    assign f = (~y & ~z) | (y & z) | (~x & z);
endmodule
```
