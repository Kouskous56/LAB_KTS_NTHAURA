# EX_10 — FSM (sequence detector)

## Khái niệm
Finite State Machine (FSM) phát hiện mẫu "101" (Mealy output).
- Mealy: output phụ thuộc state AND input.
- z=1 khi bit cuối của "101" được nhận.

## State diagram
- S0: trạng thái ban đầu (chưa match)
- S1: đã nhận "1"
- S2: đã nhận "10"
- Nhận "1" ở S2: output z=1, chuyển S1 (overlap)

## Ứng dụng
- Sequence detector.
- Protocol parser.
- Pattern matching.
