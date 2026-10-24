# EXP 3 — Mạch cho sẵn (Figure 1.6), tối giản F2

## Mục tiêu
Cài đặt mạch logic cho sẵn, sau đó tối giản và so sánh kết quả.

## Phân tích (theo sổ tay kỹ thuật)
F1 = XNOR(v1, v2) với:
- s = x̄ + y
- v1 = NOT(s · z̄) = x·ȳ + z
- v2 = NOT(y · z̄) = ȳ + z
F1 = x + y + z
F2 = x + y + z (tối giản, cùng kết quả)

## Bảng chân lý (Table 1.3)
x y z | F1 | F2
0 0 0 | 0 | 0
0 0 1 | 1 | 1
0 1 0 | 1 | 1
0 1 1 | 1 | 1
1 0 0 | 1 | 1
1 0 1 | 1 | 1
1 1 0 | 1 | 1
1 1 1 | 1 | 1

## Nhận xét
- F1 và F2 cho cùng kết quả logic vì F2 là dạng tối giản của F1.
- Cổng cuối hình là XNOR (không phải XOR đơn).
- Mạch tối giản chỉ cần 1 cổng OR 3 đầu vào (hoặc 2 cổng OR 2 đầu vào).
