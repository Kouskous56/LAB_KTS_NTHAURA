# EX_13 — Thiết Kế Hàm f(w,x,y,z) = w + xyz Chỉ Dùng Full Adder

## Khái niệm
Thiết kế hàm Boolean f(w, x, y, z) = w + xyz (trong đó + là OR, · là AND)
chỉ sử dụng các bộ cộng toàn phần (Full Adder).

## Nguyên lý: Full Adder như cổng logic

### Full Adder với cin = 0 → Cổng AND
- S = a ⊕ b ⊕ 0 = a ⊕ b
- Cout = a·b + a·0 + b·0 = a·b
- **Cout = a AND b**

### Full Adder với cin = 1 → Cổng OR
- S = a ⊕ b ⊕ 1 = NOT(a ⊕ b)
- Cout = a·b + a·1 + b·1 = a·b + a + b = a + b (vì a·b ≤ a+b)
- **Cout = a OR b**

## Thiết kế

### Bước 1: Tính xyz = x AND y AND z
- FA1: a=x, b=y, cin=0 → Cout1 = x AND y
- FA2: a=Cout1, b=z, cin=0 → Cout2 = (x AND y) AND z = x AND y AND z

### Bước 2: Tính f = w OR xyz
- FA3: a=w, b=Cout2, cin=1 → Cout3 = w OR Cout2 = w OR (x AND y AND z) = f

### Sơ đồ
```
x ─┐
   ├──[FA1 cin=0]── Cout1=x·y ─┐
y ─┘                            │
                                ├──[FA2 cin=0]── Cout2=x·y·z ─┐
z ──────────────────────────────┘                            │
                                                             ├──[FA3 cin=1]── f=w+x·y·z
w ───────────────────────────────────────────────────────────┘
```

## Ứng dụng
- Universal building block: Full Adder có thể tạo AND và OR.
- Thiết kế mạch logic từ một loại component duy nhất.
- Giảm số loại IC trong thiết kế.
- Minh họa tính vạn năng của Full Adder.
