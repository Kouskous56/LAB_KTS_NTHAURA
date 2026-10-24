# EX_02 — Mealy FSM (2 states)

## Khái niệm
Mealy FSM: output phụ thuộc trạng thái VÀ input.
- Output c? thể thay đổi ngay khi input thay đổi (không cần chờ clock).
- Phản ứng nhanh hơn Moore, nhưng có thể glitch.

## So s?nh Moore vs Mealy

| Đặc điểm | Moore | Mealy |
|---|---|---|
| Output depends on | state only | state + input |
| Output changes | after clock edge | immediately when input changes |
| Number of states | more | fewer |
| Glitch | no | possible |
| Ease of testing | easier | harder |
