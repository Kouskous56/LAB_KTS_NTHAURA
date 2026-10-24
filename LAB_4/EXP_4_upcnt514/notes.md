# EXP_4 — Bộ đếm 4-bit từ 5 đến 14

## Mục tiêu
Cài đặt bộ đếm 4-bit theo chu kỳ mười giá trị.

## Đặc tả
- Output count nối `LED[3:0]`, RST nối `SW[0]`, clock 1 Hz.
- Chuỗi đếm tuần hoàn hợp lý: `5,6,7,8,9,10,11,12,13,14,5`.
- Manual nói reset về 0 nhưng cũng nói counter từ 5 đến 14, chưa chỉ rõ reset state có phải 0 hay 5.

## Lưu ý
- Cần ghi rõ lựa chọn thiết kế. Cách bám sát pinout/reset nêu trong manual là reset count về 0 rồi ở cạnh hoạt động kế tiếp nạp 5.
- Test các biên: reset, 0→5 (nếu áp dụng), 13→14 và 14→5; tránh để trạng thái 15 chạy thành 0 ngoài ý muốn.

## Pin (Nexys A7)
- CLK100MHZ, SW[0]=rst (active high), LED[3:0]=count (5..14).
