# DIGITAL_SYSTEMS — 10 bài thiết kế hệ thống số (thực tế)

Thư mục này chứa 10 bài tập từ cơ bản đến nâng cao về thiết kế
hệ thống số, lấy cảm hứng từ các vấn đề thực tế,
kèm code SystemVerilog, testbench và ghi chú.

## Danh sách bài tập

| Bài | Nội dung | File chính | Kết quả tb |
|---|---|---|---|
| EX_01 | Digital Clock (HH:MM:SS) | `digital_clock.sv` | ALL TESTS PASS |
| EX_02 | PWM Generator | `pwm_gen.sv` | ALL TESTS PASS |
| EX_03 | UART Transmitter (8N1) | `uart_tx.sv` | ALL TESTS PASS |
| EX_04 | Alarm Clock | `alarm_clock.sv` | ALL TESTS PASS |
| EX_05 | Digital Thermometer (simple) | `thermometer.sv` | ALL TESTS PASS |
| EX_06 | Calculator (simple ALU) | `calc.sv` | ALL TESTS PASS |
| EX_07 | Smart Home Controller | `smart_home.sv` | ALL TESTS PASS |
| EX_08 | 4-way Traffic Light | `traffic_4way.sv` | ALL TESTS PASS |
| EX_09 | Advanced Elevator | `elevator_adv.sv` | ALL TESTS PASS |
| EX_10 | Digital Lock (password) | `digital_lock.sv` | ALL TESTS PASS |
| EX_11 | Arithmetic Unit (AU) 4-bit | rithmetic_unit.sv | ALL TESTS PASS |
| EX_12 | Logic Gates from NAND | gates_from_nand.sv | ALL TESTS PASS |
| EX_13 | Function from Full Adder | 
| EX_14 | Counter 0 to 42 (74393) | counter_0_42.sv | ALL TESTS PASS |
| EX_15 | VHDL Circuit (mux2to1) | cau_2.sv | ALL TESTS PASS |
| EX_16 | Function F(A,B,C,D) | 
| EX_17 | Static-1 Hazard | hazard.sv | ALL TESTS PASS |
| EX_18 | SR-FF 3-bit Counter | counter_sr.sv | ALL TESTS PASS |
unc_f.sv | ALL TESTS PASS |
unc_from_fa.sv | ALL TESTS PASS |

## Cách chạy testbench

```powershell
cd DIGITAL_SYSTEMS\EX_01_digital_clock
iverilog -g2012 -o tb.vvp *.sv
vvp tb.vvp
```

## Khái niệm chính

### Digital Clock
- Đồng hồ số: HH:MM:SS với 12/24h mode.
- Seconds: 0-59, Minutes: 0-59, Hours: 0-23 (24h) hoặc 1-12 (12h).

### PWM Generator
- Điều khiển độ rộng xung để điều khiển công suất.
- duty = 0% → always 0; duty = 50% → 50% high; duty = 100% → always 1.

### UART Transmitter
- 8N1: 8 data bits, no parity, 1 stop bit.
- IDLE → START → DATA → STOP.

### Alarm Clock
- Đặt giờ, báo thức, tắt báo thức.
- So sánh giờ hiện tại với giờ báo thức.

### Digital Thermometer
- Đọc nhiệt độ, so sánh với ngưỡng, báo động.
- alarm = 1 khi temp > threshold.

### Calculator
- Cộng, trừ, nhân, chia.
- op=00: add, op=01: sub, op=10: mul, op=11: div.

### Smart Home Controller
- Điều khiển đèn, quạt, báo động, khóa cửa.
- 4 chế độ: Auto, Manual, Night, Away.

### 4-way Traffic Light
- 4 hướng (NS, EW).
- State: NS_G, NS_Y, EW_G, EW_Y.
- Timer: 5s green, 2s yellow.

### Advanced Elevator
- Thang máy 4 tầng với up/down và door open/close.

### Digital Lock
- Khóa số: nhập mật khẩu đúng → unlock; sai → error.
- Password: 1,0,1 (3-bit sequence).

## Ứng dụng
- Đồng hồ số, PWM, UART.
- Alarm clock, thermometer.
- Calculator, smart home.
- Traffic light, elevator, digital lock.
