# EX_05 — Sequence detector "1101" (Moore, overlapping)

## Khái niệm
FSM phát hiện mẫu "1101" (Moore output).
- Moore: output chỉ phụ thuộc state (delayed 1 clock).
- Overlapping: sau khi phát hiện, quay về S1 (vì bit cuối "1" có thể là bắt đầu mới).

## So sánh Mealy vs Moore
- Mealy: z=1 ngay khi nhận bit cuối (cùng clock).
- Moore: z=1 ở clock tiếp theo (delay 1 clock).

## Ứng dụng
- Sequence detector.
- Protocol parser.
- Pattern matching with overlap.
