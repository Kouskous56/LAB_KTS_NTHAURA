# EX_05 — Decoder as Boolean function generator

## Khái niệm
Decoder có thể dùng để triển khai hàm Boolean. Với hàm 3 biến, dùng decoder 3-to-8:
- Address lines = các biến (x, y, z).
- Enable = 1 (active).
- Output = NAND của các output active-low tại các vị trí minterm.

## Hàm
f = Σm(0,2,5,7) = x̄ȳžz + x̄yz̄ + xưyz + xyz
Bảng chân lý: 1,0,1,0,0,1,0,1.

## So sánh với MUX
- MUX: data inputs = giá trị hàm, select = biến, output = f (direct).
- Decoder: address = biến, outputs = minterm (active-low), f = NAND/NOR của selected outputs.
- Decoder cần thêm cổng NAND/NOR để kết hợp outputs.
