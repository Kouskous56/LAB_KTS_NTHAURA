# PREP 4 — FSM bốn trạng thái (Figure 3.4)

## State assignment và chuyển trạng thái

Mã hóa: A=00, B=01, C=10, D=11. X được lấy mẫu ở cạnh lên clock:

| Trạng thái hiện tại | S1S0 | X=0 → trạng thái kế | X=1 → trạng thái kế |
|---|:---:|---|---|
| A | 00 | A (00) | B (01) |
| B | 01 | A (00) | D (11) |
| C | 10 | A (00) | B (01) |
| D | 11 | A (00) | C (10) |

Hàng D,X=0 được bổ sung từ sơ đồ trạng thái: Table 3.2 in trong manual dường như bỏ hàng này,
nhưng đường D→A khi X=0 có trong hình và logic next-state cần định nghĩa đủ cả 8 tổ hợp.

## Suy ra phương trình next-state

Gọi D1,D0 là đầu vào D của hai FF, cũng chính là S1+,S0+:

    D1 = S1+ = X·S0
    N  = (S1·S0)̄
    D0 = S0+ = X·N = X·(S1·S0)̄

Diễn giải nhanh theo X: khi X=0, cả hai phương trình bằng 0 nên mọi trạng thái về A.
Khi X=1: A→B, B→D, C→B, D→C.

## Mạch IC và pin-to-pin

Logic dùng một 74LS74 (hai FF), một 74LS00 (NAND tạo N) và một 74LS08 (hai AND).
Lấy FF1 lưu S1 và FF2 lưu S0:

| 74LS74 | Kết nối |
|---|---|
| pin 1,13 `/CLR1,/CLR2` | RESET_n chung, kéo lên +5 V qua khoảng 10 kΩ; nút reset kéo xuống GND |
| pin 2 D1 | 74LS08 pin 3 = X·S0 |
| pin 3,11 CLK1,CLK2 | clock chung |
| pin 4,10 `/PRE1,/PRE2` | +5 V |
| pin 5 Q1 | S1; đưa ra LED và 74LS00 pin 1 |
| pin 9 Q2 | S0; đưa ra LED, 74LS00 pin 2 và 74LS08 pin 2 |
| pin 12 D2 | 74LS08 pin 6 = X·N |
| pin 7,14 | GND, +5 V |

| IC logic | Kết nối |
|---|---|
| 74LS00 pin 1,2 | S1,S0; pin 3 xuất N=`(S1S0)̄` |
| 74LS08 pin 1,2,3 | X,S0 → D1; pin 3 nối FF1 D pin 2 |
| 74LS08 pin 4,5,6 | X,N → D0; pin 6 nối FF2 D pin 12 |

74LS00 pinout cổng thường: 1,2→3; 4,5→6; 9,10→8; 12,13→11. 74LS08 cùng sơ đồ cổng.
Nối nguồn đúng pin 14/7. Không dùng các đầu vào logic thả nổi.

## Trace quy định

Reset ban đầu về A, sau đó áp dụng lần lượt `X=0,1,1,0,0,0,1`, mỗi giá trị trước một xung clock:

| Bước | X | Trạng thái sau cạnh | S1S0 |
|---|---:|---|:---:|
| Initial/reset | — | A | 00 |
| 1 | 0 | A | 00 |
| 2 | 1 | B | 01 |
| 3 | 1 | D | 11 |
| 4 | 0 | A | 00 |
| 5 | 0 | A | 00 |
| 6 | 0 | A | 00 |
| 7 | 1 | B | 01 |

Đổi X khi clock ở mức không hoạt động, chờ ổn định rồi tạo một cạnh lên sạch.
