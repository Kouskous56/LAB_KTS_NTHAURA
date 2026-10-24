# EX_01 — Moore FSM (2 states: idle/active)

## Khái niệm
Moore FSM: output chỉ phụ thuộc trạng thái (state), không phụ thuộc input.
- 2 trạng thái: IDLE (z=0), ACTIVE (z=1).
- Chuyển: IDLE → ACTIVE khi x=1; ACTIVE → IDLE khi x=0.

## So sánh Moore vs Mealy
- Moore: output ổn định, dễ kiểm tra, nhưng có thể cần nhiều state hơn.
- Mealy: output phụ thuộc state + input, phản ứng nhanh hơn, nhưng có thể glitch.

## Ứng dụng
- Control logic, state machine đơn giản.
- LED indicator, status display.
