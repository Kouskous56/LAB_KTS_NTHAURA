# PREP 4 — Sơ đồ nối Pmod JA với 6 LED

## Mapping theo Experiment 1

| Tín hiệu | Chân JA | LED breadboard |
|---|---:|---|
| NS_GREEN | JA1 | LED xanh NS |
| NS_YELLOW | JA2 | LED vàng NS |
| NS_RED | JA3 | LED đỏ NS |
| EW_GREEN | JA4 | LED xanh EW |
| EW_YELLOW | JA7 | LED vàng EW |
| EW_RED | JA8 | LED đỏ EW |

## Nối dây

Cho mỗi output: chân JA → điện trở nối tiếp 330 Ω (hoặc giá trị trong khoảng được manual cho phép) → anode LED; cathode LED → GND chung.
Có thể đảo vị trí resistor trong nhánh nối tiếp nhưng không bỏ resistor.
Không nối 3.3 V hoặc 5 V trực tiếp vào output; không đưa 5 V vào chân JA.
Tất cả tín hiệu FPGA và breadboard phải chung tham chiếu GND.

## Code SystemVerilog (top-level)

```systemverilog
module top_traffic (
    input  logic CLK100MHZ,
    input  logic BTNC,
    input  logic [1:0] SW,
    output logic JA1, JA2, JA3, JA4, JA7, JA8,
    output logic [6:0] seg,
    output logic [7:0] an
);
    // ... instantiate clock divider, FSM, seg7 scan
    // map outputs to JA pins
endmodule
```

## XDC (Nexys A7-100T Master XDC)

Chỉ uncomment các dòng cho: CLK100MHZ, BTNC, SW[0], SW[1],
JA1, JA2, JA3, JA4, JA7, JA8, CA..CG, AN[0], AN[1].
Copy chính xác `PACKAGE_PIN` và `IOSTANDARD` từ XDC chính thức.

## Bình luận
- Pmod 12 chân còn có chân nguồn và GND; đối chiếu sơ đồ đầu nối/board manual để không nhầm vị trí cơ khí với số chân tín hiệu.
- Tạo sáu port top-level với tên khớp XDC, hoặc bus JA và sửa `get_ports` tương ứng.
