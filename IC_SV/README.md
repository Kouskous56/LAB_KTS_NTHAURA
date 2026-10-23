# IC_SV — Thư viện submodule SystemVerilog cho các IC logic phổ biến

Thư mục này chứa các module SystemVerilog mô phỏng chức năng của các IC số phổ biến
(dòng 74xx). Mỗi IC có một file `<ic>.sv` (module) và `tb_<ic>.sv` (testbench tự kiểm tra).
Tất cả testbench biên dịch được với `iverilog -g2012` và in `ALL TESTS PASS`.

## Cấu trúc

```
IC_SV/
├── gates/          # IC cổng logic
├── combinational/  # IC tổ hợp (MUX, decoder, encoder, adder, ALU, buffer)
├── sequential/     # IC tuần tự (flip-flop, latch, counter, shift register)
├── memory/         # IC nhớ (RAM, register file)
├── misc/           # IC hỗ trợ (buffer open-collector, monostable)
└── README.md       # catalog này
```

## Cách dùng

```powershell
cd IC_SV\gates
iverilog -g2012 -o tb.vvp ic_7400.sv tb_7400.sv
vvp tb.vvp
```

## Danh mục IC

### 1. Cổng logic (`gates/`)

| IC | Chức năng | Module |
|---|---|---|
| 7400 | Quad 2-input NAND | `ic_7400` |
| 7402 | Quad 2-input NOR | `ic_7402` |
| 7404 | Hex inverter | `ic_7404` |
| 7408 | Quad 2-input AND | `ic_7408` |
| 7410 | Triple 3-input NAND | `ic_7410` |
| 7414 | Hex Schmitt-trigger inverter | `ic_7414` |
| 7420 | Dual 4-input NAND | `ic_7420` |
| 7430 | 8-input NAND | `ic_7430` |
| 7432 | Quad 2-input OR | `ic_7432` |
| 7486 | Quad 2-input XOR | `ic_7486` |
| 74266 | Quad 2-input XNOR | `ic_74266` |

### 2. Tổ hợp (`combinational/`)

| IC | Chức năng | Module |
|---|---|---|
| 74125 | Quad tri-state buffer (OE active low) | `ic_74125` |
| 74138 | 3-to-8 decoder (active-low outputs) | `ic_74138` |
| 74139 | Dual 2-to-4 decoder | `ic_74139` |
| 74148 | 8-to-3 priority encoder | `ic_74148` |
| 74151 | 8-to-1 multiplexer | `ic_74151` |
| 74153 | Dual 4-to-1 multiplexer | `ic_74153` |
| 74157 | Quad 2-to-1 multiplexer | `ic_74157` |
| 74181 | 4-bit ALU | `ic_74181` |
| 74244 | Octal buffer (OE active low) | `ic_74244` |
| 74283 | 4-bit full adder (fast carry) | `ic_74283` |
| 7447 | BCD to 7-segment (common anode) | `ic_7447` |
| 7483 | 4-bit full adder | `ic_7483` |

### 3. Tuần tự (`sequential/`)

| IC | Chức năng | Module |
|---|---|---|
| 7474 | Dual D flip-flop (preset/clear, pos edge) | `ic_7474` |
| 7475 | Quad D latch (level sensitive) | `ic_7475` |
| 7476 | Dual JK flip-flop (neg edge, preset/clear) | `ic_7476` |
| 74163 | 4-bit sync counter (clear/load/enable) | `ic_74163` |
| 74164 | 8-bit shift register (serial in, parallel out) | `ic_74164` |
| 74165 | 8-bit shift register (parallel load, serial out) | `ic_74165` |
| 74166 | 8-bit shift register (parallel load, serial out, clk inhibit) | `ic_74166` |
| 74193 | 4-bit up/down counter | `ic_74193` |
| 74194 | 4-bit bidirectional shift register | `ic_74194` |
| 74373 | Octal D latch (OE active low) | `ic_74373` |
| 74374 | Octal D flip-flop (OE active low, pos edge) | `ic_74374` |

### 4. Nhớ (`memory/`)

| IC | Chức năng | Module |
|---|---|---|
| 7489 | 64-bit RAM (16×4) | `ic_7489` |
| 74670 | 4×4 register file | `ic_74670` |

### 5. Hỗ trợ (`misc/`)

| IC | Chức năng | Module |
|---|---|---|
| 7406 | Hex inverter (open-collector, HV) | `ic_7406` |
| 7407 | Hex buffer (open-collector, HV) | `ic_7407` |
| 74121 | Monostable multivibrator | `ic_74121` |
| 74122 | Retriggerable monostable | `ic_74122` |

## Tổng số

- **40 IC** (11 cổng + 12 tổ hợp + 11 tuần tự + 2 nhớ + 4 hỗ trợ)
- Mỗi IC có testbench tự kiểm tra in `ALL TESTS PASS`.
- Tất cả biên dịch được với `iverilog -g2012`.

## Ghi chú

- Các IC open-collector (7406, 7407, 7489, 74266) được mô phỏng ở mức chức năng (không mô phỏng điện áp/điện trở kéo lên).
- 7414 (Schmitt trigger) mô phỏng như inverter thường (không có trễ trội).
- 74181 ALU là mô hình đơn giản hoá (16 hàm logic + cộng/trừ).
- 74121/74122 monostable dùng độ trễ cố định `#100` (không phụ thuộc RC).
- 7489 xuất dữ liệu đảo (inverted) đúng với IC thật.
