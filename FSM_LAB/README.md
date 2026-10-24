# FSM_LAB — 10 bài tập FSM (cơ bản → nâng cao)

Thư mục này chứa 10 bài tập từ cơ bản đến nâng cao về Finite State Machine (FSM),
kèm code SystemVerilog, testbench và ghi chú.

## Danh sách bài tập

| Bài | Nội dung | File chính | Kết quả tb |
|---|---|---|---|
| EX_01 | Moore FSM (2 states) | `moore_basic.sv` | ALL TESTS PASS |
| EX_02 | Mealy FSM (2 states) | `mealy_basic.sv` | ALL TESTS PASS |
| EX_03 | FSM with sync/async reset | `fsm_reset.sv` | ALL TESTS PASS |
| EX_04 | Sequence detector "101" (Mealy) | `fsm_seqdet_101.sv` | ALL TESTS PASS |
| EX_05 | Sequence detector "1101" (Moore) | `fsm_seqdet_1101.sv` | ALL TESTS PASS |
| EX_06 | Traffic light (3 states) | `traffic_light.sv` | ALL TESTS PASS |
| EX_07 | Vending machine | `vending.sv` | ALL TESTS PASS |
| EX_08 | Elevator controller | `elevator.sv` | ALL TESTS PASS |
| EX_09 | UART state machine | `uart_fsm.sv` | ALL TESTS PASS |
| EX_10 | Parametric FSM | `param_fsm.sv` | ALL TESTS PASS |

## Cách chạy testbench

```powershell
cd FSM_LAB\EX_01_moore_basic
iverilog -g2012 -o tb.vvp *.sv
vvp tb.vvp
```

## Khái niệm chính

### Moore vs Mealy
- **Moore**: output chỉ phụ thuộc state. Output thay đổi sau clock edge.
- **Mealy**: output phụ thuộc state + input. Output có thể thay đổi ngay khi input thay đổi.

### FSM Design Process
1. Xác định thông tin quá khứ cần nhớ.
2. Liệt kê trạng thái và output.
3. Xác định reset state và mọi chuyển trạng thái.
4. Lập state transition table và output table.
5. Suy ra RTL và test tất cả cạnh/chuỗi biên.

### Ứng dụng
- Sequence detector, protocol parser.
- Traffic light controller.
- Vending machine.
- Elevator controller.
- UART state machine.
- Control logic.