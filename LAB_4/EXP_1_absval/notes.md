# EXP_1 — Giá trị tuyệt đối của số 4-bit

## Mục tiêu
Cài đặt hàm trị tuyệt đối trên FPGA.

## Đặc tả
- Mapping: `A[3:0]=SW[3:0]`, `S[3:0]=LED[3:0]`.
- Cần xác định A là **unsigned** hay **signed two's complement**.
  - Nếu unsigned 0–15 thì absolute(A)=A, bài gần như phép nối dây.
  - Nếu signed 4-bit thì miền là −8…+7 và cần lấy bù hai khi A3=1.

## Code (signed two's complement)
```systemverilog
assign S = A[3] ? (~A + 4'd1) : A;
```

## Lưu ý
- Với A=1000₂ (−8), trị tuyệt đối bằng 8; mẫu bit kết quả 4-bit là 1000, không thể hiểu lại là +8 trong signed 4-bit.
- Nêu quy ước signed/unsigned trong bào cáo và xác nhận với giảng viên.
- Test 16 input patterns; các cặp mẫu −1/1, −7/7 và biên −8 cần được kiểm riêng.

## Pin (Nexys A7)
- SW[3:0]=A, LED[3:0]=S (trị tuyệt đối).
