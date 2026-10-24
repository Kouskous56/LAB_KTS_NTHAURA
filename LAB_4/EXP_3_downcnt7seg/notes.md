# EXP_3 — Bộ đếm xuống 3-bit và hiển thị 7 đoạn

## Mục tiêu
Cài đặt bộ đếm xuống 3-bit, đổi mỗi giây, hiển thị ở 7 đoạn.

## Đặc tả
- Counter đổi mỗi giây theo clock divider 1 Hz.
- Input reset RST tích cực cao, nối `SW[0]`.
- Output decoder gắn các cathode CA…CG; enable digit phải bằng `AN[0]=0`, `AN[7:1]=1`.
- Manual nói reset state về 0; sau khi nhả reset, hướng đếm xuống tuần hoàn 7→6…→0→7 là cách hiểu tự nhiên của 3-bit down counter.

## Bảng dự đoán sau reset

| Sự kiện | Count | Chữ số hiển thị |
|---|:---:|---:|
| Reset giữ | 000 | 0 |
| Clock 1 | 111 | 7 |
| Clock 2 | 110 | 6 |
| Clock 3 | 101 | 5 |
| Clock 4 | 100 | 4 |
| Clock 5 | 011 | 3 |
| Clock 6 | 010 | 2 |
| Clock 7 | 001 | 1 |
| Clock 8 | 000 | 0 |

## Lưu ý
- Một mâu thuẫn thiết kế cần để ý: reset về 0 rồi down-count sẽ chuyển ngay sang 7 theo modulo 8.
  Nêu quy định reset state về 0, sau khi nhả reset, ở cạnh hoạt động kế tiếp nạp 5; sau đó tăng 5→…→14→5.
- Dùng 3-bit register, cập nhật `count <= count - 1'b1` ở cạnh clock 1 Hz.
- Chỉ dùng digit phải để tránh multiplex nhiều digit.
- Mô phỏng divider bằng tham số nhỏ, nếu không sẽ cần hàng triệu clock.

## Pin (Nexys A7)
- CLK100MHZ, BTNC (reset), CA..CG=segments, AN[0]=0 (digit ph?i nh?t), LED[15:0]=0.
