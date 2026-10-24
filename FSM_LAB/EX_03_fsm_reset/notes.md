# EX_03 — FSM with sync/async reset

## Khái niệm
- **Async reset**: reset ngay khi rst=1, không chờ clock.
- **Sync enable**: chỉ cập nhật state khi en=1 và có clock edge.
- Kết hợp: async reset + sync enable.

## Ứng dụng
- Reset khẩn cấp (async).
- Clock gating / enable (sync).
- Low-power design.
