# EXP_1 — Manual Traffic Light

## Mục tiêu
Cài đặt hệ thống đèn giao thông chế độ thủ công.

## Đặc tả
- SW0=0: NS xanh, EW đỏ. SW0=1: NS đỏ, EW xanh.
- Khi SW0 đổi trong lúc pha xanh, chuyển sang pha vàng 3 giây,
  sau đó chuyển sang hướng đối diện.
- Countdown hiển thị 3,2,1 (hoặc 3,2,1,0) trong pha vàng.
- Reset về NS_GO (NS xanh, EW đỏ).

## FSM (4 trạng thái)
- NS_GO, NS_WARN, EW_GO, EW_WARN.
- Timer: 3 giây cho pha vàng.

## Pin (Nexys A7)
- CLK100MHZ, BTNC (reset), SW[0]=direction.
- JA1=NS_G, JA2=NS_Y, JA3=NS_R, JA4=EW_G, JA7=EW_Y, JA8=EW_R.
- CA..CG=segments, AN[0]=digit 0, AN[1]=digit 1.

## Lưu ý
- Timer minh họa 3,2,1,0: 0 có được giữ trọn giây không? Xác nhận với giảng viên.
- Khi SW0 đổi trong pha vàng, target_dir đã chốt khi bắt đầu pha.
- Test cả hai chiều chuyển: NS→EW và EW→NS.
