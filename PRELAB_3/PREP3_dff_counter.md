# PREP 3 — 74LS74 D-FF và bộ đếm ripple modulo 8

## Function table của một D flip-flop (74LS74)

74LS74 chứa hai D flip-flop cạnh lên. `/PRE` và `/CLR` là bất đồng bộ, tích cực mức thấp:

| `/PRE` | `/CLR` | CLK | D | Q sau tác động | Ý nghĩa |
|---:|---:|---|---:|---:|---|
| 0 | 1 | X | X | 1 | Set bất đồng bộ |
| 1 | 0 | X | X | 0 | Clear bất đồng bộ |
| 1 | 1 | cạnh lên | 0 | 0 | Chốt D=0 |
| 1 | 1 | cạnh lên | 1 | 1 | Chốt D=1 |
| 1 | 1 | không cạnh lên | X | giữ Q | Không lấy mẫu D |
| 0 | 0 | X | X | Không xác định | Không dùng |

Khi `/PRE=/CLR=1`, Q chỉ đổi ở cạnh lên của clock; cạnh xuống không chốt dữ liệu.
Không đồng thời kéo PRE và CLR xuống LOW.

## Counter ripple 3 bit modulo 8

Dùng ba FF, đặt `D=Q̄` cho mỗi tầng. FF0 nhận clock ngoài; clock tầng kế tiếp lấy từ Q̄ của tầng trước.
Q0 đảo mỗi cạnh lên clock ngoài; Q1 đổi khi Q0 giảm; Q2 đổi khi Q1 giảm.

| Số xung sau reset | Q2Q1Q0 |
|---:|:---:|
| 0 | 000 |
| 1 | 001 |
| 2 | 010 |
| 3 | 011 |
| 4 | 100 |
| 5 | 101 |
| 6 | 110 |
| 7 | 111 |
| 8 | 000 |

Mỗi tầng là ripple nên chuyển trạng thái có trễ lan truyền; có thể thấy trạng thái trung gian rất ngắn.
Đọc trạng thái sau khi mạch ổn định, không lấy mẫu quá sát cạnh.

## Đấu dây tham khảo 74LS74

Pinout DIP-14 phổ biến: FF1 có `/CLR1` pin 1, D1 pin 2, CLK1 pin 3, `/PRE1` pin 4, Q1 pin 5, Q̄1 pin 6; GND pin 7; FF2 có Q̄2 pin 8, Q2 pin 9, `/PRE2` pin 10, CLK2 pin 11, D2 pin 12, `/CLR2` pin 13; VCC pin 14.

Một bố trí ba tầng:

| Tầng | IC và Q | D nối tới | CLK nối tới |
|---|---|---|---|
| Q0 (LSB) | IC1 pin 5 | IC1 pin 6 (Q̄1) → pin 2 | clock ngoài → pin 3 |
| Q1 | IC1 pin 9 | IC1 pin 8 (Q̄2) → pin 12 | IC1 pin 6 (Q̄0) → pin 11 |
| Q2 (MSB) | IC2 pin 5 | IC2 pin 6 (Q̄) → pin 2 | IC1 pin 8 (Q̄1) → IC2 pin 3 |

Nối `/PRE` đang dùng lên +5 V; nối các `/CLR` của ba tầng chung làm RESET_n, kéo LOW để reset về 000 rồi trả HIGH trước khi đếm. Hai IC pin 14 lên +5 V, pin 7 xuống GND.

## IC cần dùng
- 2 x 74LS74 (D-FF), 74LS08 (AND), 74LS00 (NAND) nếu cần cho counter.
