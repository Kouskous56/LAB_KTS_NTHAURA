# EX_19 — Bộ Đếm Song Song 3 Bit (Câu 5)

## Khái niệm
Bộ đếm đồng bộ (song song) 3 bit Q1Q2Q3 (Q1 là MSB), với X là ngõ vào điều khiển.

## Mạch logic
- 3 D Flip-Flop (D1, D2, D3), chung clock CK.
- D1 = X XOR Q3
- D2 = Q2 XOR (Q1 AND X)
- D3 = Q1

## Phân tích trạng thái

### Case X = 0
- D1 = 0 XOR Q3 = Q3
- D2 = Q2 XOR (Q1 AND 0) = Q2
- D3 = Q1
- Chuyển trạng thái: (Q1, Q2, Q3) → (Q3, Q2, Q1) — hoán đổi Q1 và Q3, Q2 giữ nguyên.

| Trạng thái hiện tại | Trạng thái tiếp theo |
|---------------------|----------------------|
| 000 | 000 (fixed point) |
| 001 | 100 |
| 010 | 010 (fixed point) |
| 011 | 110 |
| 100 | 001 |
| 101 | 101 (fixed point) |
| 110 | 011 |
| 111 | 111 (fixed point) |

### Case X = 1
- D1 = 1 XOR Q3 = NOT Q3
- D2 = Q2 XOR (Q1 AND 1) = Q2 XOR Q1
- D3 = Q1
- Chuyển trạng thái: (Q1, Q2, Q3) → (NOT Q3, Q2 XOR Q1, Q1)

| Trạng thái hiện tại | Trạng thái tiếp theo |
|---------------------|----------------------|
| 000 | 100 |
| 100 | 111 |
| 111 | 001 |
| 001 | 000 |
| 010 | 110 |
| 110 | 101 |
| 101 | 011 |
| 011 | 010 |

### Giản đồ trạng thái (X=1): Johnson Counter
```
         000 → 100 → 111 → 001 → 000
         010 → 110 → 101 → 011 → 010
```
Hai chu trình Johnson (twisted ring) độc lập, mỗi chu trình 4 trạng thái.

## Ý nghĩa của mạch
- **X=0**: Mạch hoạt động như register hoán đổi (swap) bit ngoài, bit giữa giữ nguyên. Các trạng thái "palindrome" (Q1=Q3) là fixed point.
- **X=1**: Mạch hoạt động như **Johnson counter** (twisted ring counter) — thanh ghi dịch với feedback đảo. Có 2 chu trình độc lập, mỗi chu trình 4 trạng thái.
- Đây là mạch đa chức năng: có thể chọn giữa chế độ "hold/swap" (X=0) và "shift/Johnson" (X=1) bằng tín hiệu điều khiển X.
- Ứng dụng: thanh ghi dịch, bộ đếm Johnson, mạch xử lý tín hiệu.

## Ứng dụng
- Johnson counter (ring counter with twisted feedback).
- Shift register with control.
- State machine with multiple modes.
- Digital signal processing.
