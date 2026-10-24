# PREP 2 — Adder 4 bit và Adder/Subtractor

## Ripple-carry adder

Nối bốn full adder từ bit thấp lên bit cao. Với chỉ số bit i=1 là LSB:

    S_i = A_i ⊕ B_i ⊕ C_{i-1}
    C_i = A_i B_i + (A_i ⊕ B_i) C_{i-1}
    C0 = 0  (chế độ cộng)

FA1 nhận A1,B1,C0 và tạo S1,C1; FA2 nhận A2,B2,C1; FA3 nhận A3,B3,C2; FA4 nhận A4,B4,C3.
Đầu ra năm bit được ghi theo thứ tự `C4 S4 S3 S2 S1`.

Ví dụ `1011₂ + 0011₂`:

| Bit | Ai | Bi | Carry vào | Si | Carry ra |
|---|---:|---:|---:|---:|---:|
| 1 (LSB) | 1 | 1 | 0 | 0 | 1 |
| 2 | 1 | 1 | 1 | 1 | 1 |
| 3 | 0 | 0 | 1 | 1 | 0 |
| 4 (MSB) | 1 | 0 | 0 | 1 | 0 |

Kết quả `01110₂` (C4=0, S=1110). Kiểm tra carry cuối bằng `1111+0001=1 0000`.

## Hai cách hiện thực

**Bốn khối FA:** theo sơ đồ manual, mỗi FA dùng 2 XOR, 2 AND và 1 OR.
Tổng cộng 8 XOR, 8 AND và 4 OR: hai 74LS86, hai 74LS08, một 74LS32. C0 nối LOW trong phép cộng.

**Một 74LS283:** thay bốn khối FA bằng IC cộng 4 bit. Nối hai toán hạng theo đúng ký hiệu A/B và thứ tự bit datasheet; C0 LOW cho phép cộng; lấy S1–S4 và C4 ra LED tương ứng.

Hai cách trên là hai cấu hình lựa chọn, không phải nối nối tiếp cả khối FA và 74LS283.

## Subtraction bằng bù hai và mâu thuẫn C0

Để dùng cùng adder cho `A−B`, bù B có điều khiển bằng Sel:

    B'_i = B_i ⊕ Sel
    C0  = Sel
    Result = A + B' + C0

Sel=0: `B'=B`, C0=0, cho A+B. Sel=1: `B'=~B`, C0=1, do đó `A+~B+1=A−B` theo modulo 16.

**Mâu thuẫn manual cần giải quyết trước khi đấu dây:** phần mô tả yêu cầu Sel=0 là cộng, Sel=1 là trừ, nhưng một bước thủ tục của Experiment 2 yêu cầu nối C0 xuống GND. Nối C0 cố định LOW sẽ thực hiện `A+~B`, tức thiếu số +1 trong phép trừ, và cho kết quả sai một đơn vị modulo 16. Cách chuẩn là C0=Sel. Hỏi giảng viên/TA phiên bản đấu dây cần chấm.

Ở phép trừ bù hai, C4=1 thường biểu thị không mượn (no borrow), C4=0 biểu thị có mượn. C4 không phải bit dấu của số có dấu.

## Bảng Table 3.4 (dự đoán chuẩn, C0=Sel)

| A (dec) | B (dec) | A (bin) | B (bin) | C4S cộng | C4S trừ chuẩn |
|---:|---:|:---:|:---:|:---:|:---:|
| 10 | 11 | 1010 | 1011 | 1 0101 | 0 1111 |
| 14 | 10 | 1110 | 1010 | 1 1000 | 1 0100 |
| 12 | 4 | 1100 | 0100 | 1 0000 | 1 1000 |
| 5 | 3 | 0101 | 0011 | 0 1000 | 1 0010 |
| 4 | 5 | 0100 | 0101 | 0 1001 | 0 1111 |
| 13 | 13 | 1101 | 1101 | 1 1010 | 1 0000 |
| 6 | 9 | 0110 | 1001 | 0 1111 | 0 1101 |
| 2 | 8 | 0010 | 1000 | 0 1010 | 0 1010 |
| 1 | 2 | 0001 | 0010 | 0 0011 | 0 1111 |
| 7 | 1 | 0111 | 0001 | 0 1000 | 1 0110 |
| 15 | 6 | 1111 | 0110 | 1 0101 | 1 1001 |
| 9 | 15 | 1001 | 1111 | 1 1000 | 0 1010 |

Đây là kết quả lý thuyết của C0=Sel. Đối chiếu số học modulo 16 trước khi dùng bảng.

## IC cần dùng
- Cách 1 (4 FA): 2 x 74LS86, 2 x 74LS08, 1 x 74LS32.
- Cách 2 (74LS283): 1 x 74LS283 + 1 x 74LS86 (XOR cho bù B).
- Cả hai: thêm 74LS86 (4 XOR) cho B'=B⊕Sel.
