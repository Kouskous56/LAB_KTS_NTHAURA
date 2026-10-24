# PREP 1 — Full Adder 1 bit

## Đặc tả và phương trình

Full adder cộng ba bit đầu vào A, B, Ci. Tổng số học nằm trong khoảng 0–3, cần hai bit đầu ra:

    S  = A ⊕ B ⊕ Ci
    Co = AB + ACi + BCi

Cách phân rã thuận tiện khi dựng mạch:

    P  = A ⊕ B
    S  = P ⊕ Ci
    Co = AB + P·Ci

Carry bằng 1 khi ít nhất hai trong ba đầu vào bằng 1 (majority function).

## Bảng chân trị

| A | B | Ci | S | Co | Tổng thập phân |
|---:|---:|---:|---:|---:|---:|
| 0 | 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | 0 | 1 |
| 0 | 1 | 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 0 | 1 | 2 |
| 1 | 0 | 0 | 1 | 0 | 1 |
| 1 | 0 | 1 | 0 | 1 | 2 |
| 1 | 1 | 0 | 0 | 1 | 2 |
| 1 | 1 | 1 | 1 | 1 | 3 |

`S` là bit thấp của tổng, `Co` là bit cao.

## Triển khai cổng và kiểm tra

- Hai cổng XOR 74LS86 tạo P và S.
- Hai cổng AND 74LS08 tạo `G=AB` và `H=P·Ci`.
- Một cổng OR 74LS32 tạo `Co=G+H`.
- Cần một IC mỗi loại. Xác nhận chân nguồn và pinout với datasheet.

Quét theo thứ tự `ABCi=000…111`; nếu S sai nhưng Co đúng, kiểm tra chuỗi XOR; nếu Co sai, kiểm tra nhánh AB, P·Ci và OR.

## IC cần dùng
- 1 x 74LS86 (XOR), 1 x 74LS08 (AND), 1 x 74LS32 (OR).
