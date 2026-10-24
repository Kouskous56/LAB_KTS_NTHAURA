# EX_09 — Decoder-Encoder pair (round trip)

## Khái niệm
Kết hợp decoder và encoder để kiểm tra round trip:
- Decoder: mã 3-bit → one-hot 8-bit.
- Encoder: one-hot 8-bit → mã 3-bit.
- Kết quả: dout = din (round trip thành công).

## Ứng dụng
- Kiểm tra tính đúng đắn của decoder/encoder.
- Address translation.
- Code conversion.
