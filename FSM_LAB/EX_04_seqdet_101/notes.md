# EX_04 — Sequence detector "101" (Mealy, overlapping)

## Khái niệm
FSM phát hiện mẫu "101" trong chuỗi bit (Mealy output).
- Mealy: output phụ thuộc state + input.
- z=1 khi bit cuối của "101" được nhận.
- Overlapping: sau khi phát hiện, quay về S1 (vì bit cuối "1" có thể là bắt đầu mới).

## State diagram
- S0: trạng thái ban đầu (chưa match)
- S1: đã nhận "1"
- S2: đã nhận "10"
- Nhận "1" ở S2: output z=1, chuyển S1 (overlap)

## Ứng dụng
- Sequence detector.
- Protocol parser.
- Pattern matching.
