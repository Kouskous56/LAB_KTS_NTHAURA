# SEQ_CIRCUITS ? 10 b?i t?p m?ch tu?n t? (c? b?n ? n?ng cao)

Th? m?c n?y ch?a 10 b?i t?p t? c? b?n ??n n?ng cao v? m?ch tu?n t?,
k?m code SystemVerilog, testbench v? ghi ch?.

## Danh s?ch b?i t?p

| B?i | N?i dung | File ch?nh | K?t qu? tb |
|---|---|---|---|
| EX_01 | D Flip-Flop c? b?n (pos edge, async reset) | `dff_basic.sv` | ALL TESTS PASS |
| EX_02 | D Flip-Flop with enable | `dff_enable.sv` | ALL TESTS PASS |
| EX_03 | JK Flip-Flop | `jk_ff.sv` | ALL TESTS PASS |
| EX_04 | T Flip-Flop | `t_ff.sv` | ALL TESTS PASS |
| EX_05 | SR Latch | `sr_latch.sv` | ALL TESTS PASS |
| EX_06 | D Latch | `d_latch.sv` | ALL TESTS PASS |
| EX_07 | 4-bit counter (up) | `counter_up.sv` | ALL TESTS PASS |
| EX_08 | 4-bit counter (up/down) | `counter_ud.sv` | ALL TESTS PASS |
| EX_09 | Shift register (serial in, parallel out) | `sr_sipo.sv` | ALL TESTS PASS |
| EX_10 | FSM (sequence detector 101) | `fsm_seqdet.sv` | ALL TESTS PASS |

## C?ch ch?y testbench

```powershell
cd SEQ_CIRCUITS\EX_01_dff_basic
iverilog -g2012 -o tb.vvp *.sv
vvp tb.vvp
```

## Kh?i ni?m ch?nh

### Flip-Flop vs Latch
- **Latch**: level-sensitive (transparent khi enable=1).
- **Flip-Flop**: edge-triggered (capture t?i c?nh clock).

### C?c lo?i Flip-Flop
- **D-FF**: q = d (capture).
- **JK-FF**: J=K=1 ? toggle, kh?ng c? tr?ng th?i c?m.
- **T-FF**: T=1 ? toggle, T=0 ? hold.

### Counter
- Up counter: count t?ng 1 m?i clock.
- Down counter: count gi?m 1 m?i clock.
- Up/Down: ?i?u khi?n b?ng t?n hi?u up/down.

### Shift Register
- SIPO: serial in, parallel out.
- PISO: parallel in, serial out.
- SISO: serial in, serial out.

### FSM
- Moore: output ch? ph? thu?c state.
- Mealy: output ph? thu?c state + input.
- Sequence detector: ph?t hi?n m?u bit trong chu?i.

## ?ng d?ng
- Register, pipeline.
- Counter, frequency divider.
- Shift register, serial communication.
- Sequence detector, protocol parser.
- State machine, control logic.
