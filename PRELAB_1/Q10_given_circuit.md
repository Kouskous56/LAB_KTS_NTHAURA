# Câu 10: Phân tích mạch cho sẵn, tối giản F2

**Mạch (Figure 1.6):**
- A → NOT → input trên của OR
- B → input dưới của OR; B cũng rẽ nhánh xuống NAND dưới
- C → NOT → tạo C̄; C̄ đi đến input dưới của NAND trên (nhánh rẽ lên) và đến input trên của NAND dưới
- Output OR → input trên của NAND trên
- Output NAND trên và NAND dưới → XNOR → F

**Phân tích (theo sổ tay kỹ thuật):**
Đặt A=x, B=y, C=z:
- s = x̄ + y
- v1 = NOT(s · z̄) = x·ȳ + z
- v2 = NOT(y · z̄) = ȳ + z
- F1 = XNOR(v1, v2) = v1·v2 + v̅1·v̅2 = x + y + z
- F2 = x + y + z (tối giản)

## Bảng chân lý (F1 = F2 = x + y + z)
| x | y | z | F1 | F2 |
|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | 1 |
| 0 | 1 | 0 | 1 | 1 |
| 0 | 1 | 1 | 1 | 1 |
| 1 | 0 | 0 | 1 | 1 |
| 1 | 0 | 1 | 1 | 1 |
| 1 | 1 | 0 | 1 | 1 |
| 1 | 1 | 1 | 1 | 1 |

## Nhận xét
- F1 và F2 cho cùng kết quả logic vì F2 là dạng tối giản của F1.
- Cổng cuối hình là XNOR (không phải XOR đơn).
- Mạch gốc dùng nhiều IC (74LS04, 74LS08, 74LS32, 74LS00, 74LS86); mạch tối giản chỉ cần 1 cổng OR 3 đầu vào (hoặc 2 cổng OR 2 đầu vào).
