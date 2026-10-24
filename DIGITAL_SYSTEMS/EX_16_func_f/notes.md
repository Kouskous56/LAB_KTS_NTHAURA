# EX_16 — Thiết Kế Hàm F(A,B,C,D) = A(B⊕C) + BCD

## Khái niệm
Thiết kế hàm Boolean 4 biến F(A, B, C, D) = A(B XOR C) + B·C·D bằng 3 phương pháp khác nhau.

## Hàm F
F = A(B⊕C) + BCD
  = A·B·C̄ + A·B̄·C + B·C·D

Minterms: {7(0111), 10(1010), 11(1011), 12(1100), 13(1101), 15(1111)}

## Part a) Chỉ dùng Full Adder

### Nguyên lý
- FA với cin=0: Cout = a AND b (cổng AND)
- FA với cin=0: S = a XOR b (cổng XOR)
- FA với cin=1: Cout = a OR b (cổng OR)

### Thiết kế (5 Full Adder)
1. FA1: a=B, b=C, cin=0 → S = B⊕C (XOR)
2. FA2: a=A, b=(B⊕C), cin=0 → Cout = A AND (B⊕C)
3. FA3: a=B, b=C, cin=0 → Cout = B AND C
4. FA4: a=(B AND C), b=D, cin=0 → Cout = B·C AND D = BCD
5. FA5: a=(A·(B⊕C)), b=(BCD), cin=1 → Cout = A(B⊕C) OR BCD = F

## Part b) Dùng 1 MUX 2-1 + cổng logic

### Thiết kế
- MUX 2-1: s=B, a=A·C, b=(A·¬C) OR (C·D)
- Khi B=0: F = A·C (vì A·B·¬C=0, B·C·D=0, A·¬B·C=A·C)
- Khi B=1: F = A·¬C + C·D (vì A·B·¬C=A·¬C, B·C·D=C·D, A·¬B·C=0)
- Cần: AND(A,C), AND(A,¬C), AND(C,D), OR, MUX 2-1

## Part c) Dùng 1 IC 74138 (3-to-8 decoder) + cổng logic

### IC 74138
- 3-to-8 decoder, active low outputs (Y0..Y7).
- Enable: G1 (active high), G2A, G2B (active low).
- Khi enable: Y[i] = 0 cho minterm i, 1 cho các minterm khác.

### Thiết kế
- Dùng A,B,C làm inputs decoder, D làm enable (G1=D).
- Khi D=1: decoder active, cần minterms ABC = 011, 101, 110, 111.
- Khi D=0: decoder inactive, cần minterms ABC = 101, 110.
- Khi D=1: decoder active, can minterms ABC = 011, 101, 110, 111.
- Khi D=0: decoder inactive, can minterms ABC = 101, 110 (tinh bang logic: A AND (B XOR C)).
- F = (D AND (NOT Y3 OR NOT Y5 OR NOT Y6 OR NOT Y7)) OR (NOT D AND A AND (B XOR C))

## Ứng dụng
- Thiết kế hàm logic từ các component cơ bản.
- So sánh các phương pháp thiết kế (Full Adder vs MUX vs Decoder).
- Tối ưu hóa mạch tổ hợp.
- ALU design.
