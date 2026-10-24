# EXP_6 — Bộ cấp thức ăn/nước bằng nút đỏ/xanh

## Mục tiêu
Cài đặt FSM cấp thức ăn (FOOD) và nước (WATER) bằng nút đỏ/xanh.

## Đặc tả
- Input R (đỏ) và B (xanh) là hai nút; output FOOD và WATER.
- Quy tắc: ba lần RED liên tiếp kích hoạt FOOD; hai lần BLUE liên tiếp kích hoạt WATER.
- Khi FOOD hoặc WATER đang active, lần nhấn tiếp theo bất kỳ đưa hệ về reset.
- Mỗi lần chỉ một nút được nhấn; nếu có input sai thứ tự giữa chuỗi, quay reset.
- Clock theo manual được chia từ 100 MHz xuống 1 Hz.

## FSM (6 trạng thái Moore)

| State | Ý nghĩa | FOOD | WATER |
|---|---|---:|---:|
| IDLE | Chưa có lần nhấn hợp lệ | 0 | 0 |
| R1 | Đã nhận RED lần 1 | 0 | 0 |
| R2 | Đã nhận RED lần 2 liên tiếp | 0 | 0 |
| FOOD_ON | Đủ RED 3 lần | 1 | 0 |
| B1 | Đã nhận BLUE lần 1 | 0 | 0 |
| WATER_ON | Đủ BLUE 2 lần | 0 | 1 |

Chuyển trạng thái khi không nhấn (R=0,B=0): giữ state.
IDLE nhận RED→R1; BLUE→B1.
R1 nhận RED→R2, BLUE→IDLE.
R2 nhận RED→FOOD_ON, BLUE→IDLE.
B1 nhận BLUE→WATER_ON, RED→IDLE.
Trong FOOD_ON hoặc WATER_ON, bất kỳ nút nào được nhấn→IDLE.

## Lưu ý
- Input simultaneous R=B=1 bị loại trừ trong đặc tả. Tuy nhiên để RTL an toàn, quy định nhánh phục hồi, ví dụ đưa về IDLE hoặc giữ state và ghi rõ.
- Nút cơ khí phải debounce; nếu không, một lần bấm có thể bị đếm thành nhiều cạnh/mẫu.
- Nếu dùng switch board thay pushbutton, xác nhận cách tạo một xung bấm cho mỗi lần.

## Pin (Nexys A7)
- CLK100MHZ, BTNC (reset), SW[0]=RED, SW[1]=BLUE, LED[0]=FOOD, LED[1]=WATER.
