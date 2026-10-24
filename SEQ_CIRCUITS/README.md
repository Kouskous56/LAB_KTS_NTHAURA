# SEQ_CIRCUITS — 10 bài tập mạch tuần tự (cơ bản → nâng cao)

Thư mục này chứa 10 bài tập từ cơ bản đến nâng cao về mạch tuần tự,
kèm code SystemVerilog, testbench và ghi chú.

## Danh sách bài tập

| Bài | Nội dung | File chính | Kết quả tb |
|---|---|---|---|
| EX_01 | D Flip-Flop cơ bản (pos edge, async reset) | `dff_basic.sv` | ALL TESTS PASS |
| EX_02 | D Flip-Flop with enable | `dff_enable.sv` | ALL TESTS PASS |
| EX_03 | JK Flip-Flop | `jk_ff.sv` | ALL TESTS PASS |
| EX_04 | T Flip-Flop | `t_ff.sv` | ALL TESTS PASS |
| EX_05 | SR Latch | `sr_latch.sv` | ALL TESTS PASS |
| EX_06 | D Latch | `d_latch.sv` | ALL TESTS PASS |
| EX_07 | 4-bit counter (up) | `counter_up.sv` | ALL TESTS PASS |
| EX_08 | 4-bit counter (up/down) | `counter_ud.sv` | ALL TESTS PASS |
| EX_09 | Shift register (serial in, parallel out) | `sr_sipo.sv` | ALL TESTS PASS |
| EX_10 | FSM (sequence detector 101) | `fsm_seqdet.sv` | ALL TESTS PASS |

## Cách chạy testbench

```powershell
cd SEQ_CIRCUITS\EX_01_dff_basic
iverilog -g2012 -o tb.vvp *.sv
vvp tb.vvp
```

## Khái niệm chính

### Flip-Flop vs Latch
- **Latch**: level-sensitive (transparent khi enable=1).
- **Flip-Flop**: edge-triggered (capture tại cạnh clock).

### Các loại Flip-Flop
- **D-FF**: q = d (capture).
- **JK-FF**: J=K=1 → toggle, không có trạng thái cấm.
- **T-FF**: T=1 → toggle, T=0 → hold.

### Counter
- Up counter: count tăng 1 mỗi clock.
- Down counter: count giảm 1 mỗi clock.
- Up/Down: điều khiển bằng tín hiệu up/down.

### Shift Register
- SIPO: serial in, parallel out.
- PISO: parallel in, serial out.
- SISO: serial in, serial out.

### FSM
- Moore: output chỉ phụ thuộc state.
- Mealy: output phụ thuộc state + input.
- Sequence detector: phát hiện mẫu bit trong chuỗi.

## Ứng dụng
- Register, pipeline.
- Counter, frequency divider.
- Shift register, serial communication.
- Sequence detector, protocol parser.
- State machine, control logic.