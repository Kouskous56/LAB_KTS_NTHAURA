# PREP 1 — Full Adder (Fig. 4.1)

## Đặc tả và phương trình

Full adder cộng ba bit đầu vào A, B, Ci:

    S  = A ⊕ B ⊕ Ci
    Co = AB + ACi + BCi

Cách phân rã: P = A⊕B, S = P⊕Ci, Co = AB + P·Ci.

## Bảng chân trị

| A | B | Ci | S | Co |
|---:|---:|---:|---:|---:|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | 0 |
| 0 | 1 | 0 | 1 | 0 |
| 0 | 1 | 1 | 0 | 1 |
| 1 | 0 | 0 | 1 | 0 |
| 1 | 0 | 1 | 0 | 1 |
| 1 | 1 | 0 | 0 | 1 |
| 1 | 1 | 1 | 1 | 1 |

## Code SystemVerilog

```systemverilog
module FA_ex1 (
    input  logic a, b, ci,
    output logic s, co
);
    assign s  = a ^ b ^ ci;
    assign co = (a & b) | (a & ci) | (b & ci);
endmodule
```

## Bình luận
- Testbench kiểm tra đủ 8 tổ hợp.
- RTL Viewer sau synthesis có thể tối giản khác sơ đồ cổng.
- Cần định nghĩa độ rộng carry rõ ràng khi ghép 4-bit.
